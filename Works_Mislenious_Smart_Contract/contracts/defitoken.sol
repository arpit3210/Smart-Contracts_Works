// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract GoldSilverSwap {
    AggregatorV3Interface internal goldPriceFeed;
    AggregatorV3Interface internal silverPriceFeed;

    ERC20 public goldToken;
    ERC20 public silverToken;

    constructor(
        address _goldToken,
        address _silverToken,
        address _goldPriceFeed,
        address _silverPriceFeed
    ) {
        goldToken = ERC20(_goldToken);
        silverToken = ERC20(_silverToken);
        goldPriceFeed = AggregatorV3Interface(_goldPriceFeed);
        silverPriceFeed = AggregatorV3Interface(_silverPriceFeed);
    }

    function swapGoldForSilver(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");

        uint256 goldPrice = getGoldPrice();
        uint256 silverPrice = getSilverPrice();

        uint256 silverAmount = (_amount * goldPrice) / silverPrice;

        require(
            goldToken.balanceOf(msg.sender) >= _amount,
            "Insufficient gold balance"
        );
        require(
            silverToken.balanceOf(address(this)) >= silverAmount,
            "Insufficient silver balance"
        );

        goldToken.transferFrom(msg.sender, address(this), _amount);
        silverToken.transfer(msg.sender, silverAmount);
    }

    function swapSilverForGold(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");

        uint256 goldPrice = getGoldPrice();
        uint256 silverPrice = getSilverPrice();

        uint256 goldAmount = (_amount * silverPrice) / goldPrice;

        require(
            silverToken.balanceOf(msg.sender) >= _amount,
            "Insufficient silver balance"
        );
        require(
            goldToken.balanceOf(address(this)) >= goldAmount,
            "Insufficient gold balance"
        );

        silverToken.transferFrom(msg.sender, address(this), _amount);
        goldToken.transfer(msg.sender, goldAmount);
    }

    function buyGold(uint256 _amount) external payable {
        require(_amount > 0, "Amount must be greater than zero");

        uint256 goldPrice = getGoldPrice();
        uint256 totalPrice = (goldPrice * _amount);

        require(msg.value >= totalPrice, "Insufficient ETH");

        goldToken.transfer(msg.sender, _amount);
    }

    function buySilver(uint256 _amount) external payable {
        require(_amount > 0, "Amount must be greater than zero");

        uint256 silverPrice = getSilverPrice();
        uint256 totalPrice = (silverPrice * _amount);

        require(msg.value >= totalPrice, "Insufficient ETH");

        silverToken.transfer(msg.sender, _amount);
    }

    function getGoldPrice() public view returns (uint256) {
        (, int256 price, , , ) = goldPriceFeed.latestRoundData();
        return uint256(price);
    }

    function getSilverPrice() public view returns (uint256) {
        (, int256 price, , , ) = silverPriceFeed.latestRoundData();
        return uint256(price);
    }
}
