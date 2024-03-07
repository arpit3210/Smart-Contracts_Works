// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Gold is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
// 0x5691a4c27C4cff4F043347B693be15C4fcbDe5CE   // contract address eth
// account address //   0x80Cd3270c3a7650f0220e789375e5759375F2e98
//  POlygon  