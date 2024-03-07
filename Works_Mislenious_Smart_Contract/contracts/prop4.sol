// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract Property is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {

        uint256 private tokenPrice = 24219;

    // ** we can change the delay and price of token time as well according to our requirements.....

    constructor() ERC20("BLOCIMMOTOKEN-PROP4-SUBURBIA-CA", "BPSUCA") ERC20Permit("BLOCIMMOTOKEN-PROP4-SUBURBIA-CA") {
        // _mint(msg.sender, 10000 * 10 ** decimals());
        _mint(msg.sender, 2800);
    }

    function buyTokens(uint256 amount) public payable {
        require(amount > 0, "Amount must be greater than zero");
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

    function setTokenPrice(uint256 price) external onlyOwner {
        tokenPrice = price;
    }

    function getTokenPrice() external view returns (uint256) {
        return tokenPrice;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
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
