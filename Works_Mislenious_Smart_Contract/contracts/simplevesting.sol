// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol";

contract vesting {
    IERC20 public token;
    address public receiver;
    uint256 public amount;
    uint256 public expiry;
    bool public locked = false;
    bool public claimed = false;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function lock(
        address _from,
        address _receiver,
        uint256 _amount,
        uint256 _expiry
    ) public {
        require(!locked, "amount has been alredy locked");
        token.transferFrom(_from, address(this), _amount);
        receiver = _receiver;
        amount = _amount;
        expiry = _expiry;
        locked = true;
    }

    function withdraw() public {
        require(
            block.timestamp >= expiry,
            "Please wait for till expiry date for locked amount"
        );
        require(locked, "No amount locked: ask for admin of the contract");
        require(!claimed, "amount already claimed");
        token.transfer(msg.sender, amount);
        claimed = true;
    }

    function gettime() external view returns (uint256) {
        return block.timestamp;
    }
}

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10000 * 10**decimals());
    }
}
