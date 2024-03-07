// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";


contract Gold is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    AggregatorV3Interface internal priceFeed;

    //   uint256 private tokenPrice = 10 * 10**18; // $10 in MATIC (with 18 decimal places)
    uint256 public tokenPrice;
    uint256 private constant REDEMPTION_DELAY = 2 minutes;

    // ** we can change the delay and price of token time as well according to our requirements.....

    struct Redemption {
        address account;
        uint256 amount;
        uint256 redeemTime;
    }

    // 0x80Cd3270c3a7650f0220e789375e5759375F2e98   owner
    //  0xc7DC86531407Ddc5B4C9C06C30F2aEa5eF8E652b   polygon contract address

    mapping(address => Redemption) private redemptions;

    constructor(address _priceFeedAddress)
        ERC20("Gold", "GLD")
        ERC20Permit("Gold")
    {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
        _mint(msg.sender, 10000);
    }

    function getTokenPrice() external view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Price not available");

        // Chainlink price is in 8 decimal places for MATIC/USD feed
        // uint256(price) * 10**10: This multiplication converts the price from MATIC/USD (8 decimal places) to MATIC (18 decimal places).
        //So, maticPriceInUSD is the price in MATIC per 1 USD, adjusted to have 18 decimal places.

        uint256 maticPriceInUSD = uint256(price) * 10**10;

        // Calculate equivalent token price in MATIC
        uint256 equivalentTokenPrice = (1 * 10**18 * 1e18) / maticPriceInUSD;
        return equivalentTokenPrice;
    }

    function buyTokens(uint256 amount) public payable {
        require(amount > 0, "Amount must be greater than zero");
        uint256 price = getTokenPrice();
        require(msg.value >= amount * tokenPrice, "Insufficient payment");

        _transfer(owner(), msg.sender, amount);

        // Send the amount in wei to the owner's account
        payable(owner()).transfer(amount * tokenPrice);
    }

    function sellTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _transfer(msg.sender, owner(), amount);

        // Calculate the value of tokens being sold in wei
        uint256 value = amount * tokenPrice;

        // Send the value in wei to the seller's account
        payable(msg.sender).transfer(value);
    }

    function redeemGold(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(
            redemptions[msg.sender].redeemTime == 0,
            "Redemption already initiated"
        );

        redemptions[msg.sender] = Redemption(
            msg.sender,
            amount,
            block.timestamp + REDEMPTION_DELAY
        );
    }

    function claimRedeemedGold() public {
        require(
            redemptions[msg.sender].redeemTime != 0,
            "No redemption initiated"
        );
        require(
            block.timestamp >= redemptions[msg.sender].redeemTime,
            "Redemption period not passed"
        );

        uint256 amount = redemptions[msg.sender].amount;
        delete redemptions[msg.sender];
        _burn(msg.sender, amount);

        // Perform the action of redeeming the real gold to the user
        // This action is not implemented in the contract and needs to be done externally
    }

    // function setTokenPrice(uint256 maticPriceInUSD) external onlyOwner {
    //     require(maticPriceInUSD > 0, "Price must be greater than zero");

    //     // Calculate equivalent token price in MATIC
    //     uint256 equivalentTokenPrice = (10 * 10**18 * 1e18) / maticPriceInUSD;

    //     tokenPrice = equivalentTokenPrice;
    // }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
