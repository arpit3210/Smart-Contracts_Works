// SPDX-License-Identifier:GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract ifelse {
    // This if else statement works same as in other programming languages

    // note= if else statement only works in function, not outside works of function

    // Function for check value is greater, lesser and equal to 100
    function CheckNum(uint256 x) public pure returns (string memory) {
        if (x > 100) {
            return "value is greater than 100";
        } else if (x < 100) {
            return "value is less than 100";
        } else {
            return "value is equal to 100";
        }
    }
}
