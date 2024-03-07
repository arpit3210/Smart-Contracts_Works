// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract pureView {
    uint256 public temp = 1000;

    // view pure and simple function
    // view fuction can only read
    // pure function can not read and write the data for (state var, local var, global var)

    //pure and view keywords use in function

    // for use of gloval varibale use view function>> we can change the value of global variables
    function getBlockNumber() public view returns (uint256) {
        return block.number;
    }

    // when we change the value of state variable we never use pure/view
    function changeTempValue() public returns (uint256) {
        temp -= 500;
        return (temp);
    }  // this is Simple Function

    // here we are just reading the value of state var -- using view function
    function GetTempValue() public view returns (uint256) {
        return temp;
    }

    // here we are using pure function because we are not doing anything
    // with state, global variable -- not changing value or not reading value of state,global
    function addtion(uint256 _x, uint256 _y) public pure returns (uint256) {
        uint256 add;
        add = _x + _y;
        return add;
    }
}
