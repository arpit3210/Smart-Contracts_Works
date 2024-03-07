// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract useString {
    string public name = "nil";
    string public str = "kuchbhi"; // state var

    function localstring() public pure returns (string memory) {
        // string bydefault stores in storage{Blockchain}
        // as we know state variables stores in local memory
        // memory and calldata
        // memory-  data can be change
        // calldata-  data will not change again if we uses calldata
        // memory keyword consume High gas as compare to calldata keywords

        string memory nam = "asfjhsjd";
        return nam;
    }

    // during the param in function memoory and calldata keyword are required
    function changename(string memory _name) public {
        name = _name;
    }
}
