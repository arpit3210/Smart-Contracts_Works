// SPDX-License-Identifier: GBL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract functions {
    constructor() {}

    uint256 age = 10; // default visibility is internal for state variable

    // for function default visibility is private

    function addition(uint8 _x, uint8 _y) public pure returns (uint256) {
        uint256 y = _x + _y;
        return y;
    }

    function change_age() public {
        age = age + 1; // age+=1;
    }

    function getAge() public view returns (uint256) {
        return age;
    }
}
// use of function
