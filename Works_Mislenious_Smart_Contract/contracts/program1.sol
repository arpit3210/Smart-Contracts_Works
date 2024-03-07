// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
error InvalidInput();
contract CalculateArea {
    //this function returns area of square
    function squareArea(uint256 a) public pure returns (uint256) {
        if (a == 0) {
            revert InvalidInput();
        }
        uint256 area;

        assembly {
            // Multiply num by itself
            area := mul(a, a)
        }

        return area;
    }

    //this function returns area of rectangle
    function rectangleArea(uint256 a, uint256 b) public pure returns (uint256) {
        if (a == 0 || b == 0) {
            revert InvalidInput();
        }
        uint256 area;

        assembly {
            // Multiply a by b to calculate the area
            area := mul(a, b)
        }

        return area;
    }
}