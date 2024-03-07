// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DynamicPriceContract {
    address public tokenAddress;
    address public oracleAddress; // Address of Chainlink MATIC/USD price feed

    AggregatorV3Interface internal priceFeed;

    event Purchase(address indexed buyer, uint256 amount);

    constructor(address _tokenAddress, address _oracleAddress) {
        tokenAddress = _tokenAddress;
        oracleAddress = _oracleAddress;
        priceFeed = AggregatorV3Interface(_oracleAddress);
    }

    function buy() external payable {
        uint256 currentPrice = getCurrentPrice(); // Get MATIC price in USD
        uint256 requiredMATIC = (10 * 10**18 * 1e18) / currentPrice; // Calculate required MATIC

        require(msg.value >= requiredMATIC, "Insufficient MATIC sent");

        (bool success, ) = address(this).call{value: msg.value}("");
        require(success, "Transfer failed");

        emit Purchase(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == owner(), "Only the owner can withdraw");

        IERC20(tokenAddress).transfer(msg.sender, address(this).balance);
    }

    function getCurrentPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        return uint256(price);
    }

    function owner() internal view returns (address) {
        return address(this);
    }
}
