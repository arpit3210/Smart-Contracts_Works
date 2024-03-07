// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "invalid address");
        _;
    }

    function changeowner(address _newowner) public onlyOwner {
        require(_newowner != address(0), "something wrong");
        owner = _newowner;
    }

    function OnlyOwnerCanAcess() public onlyOwner {
        //code
    }
}
