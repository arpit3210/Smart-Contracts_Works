// SPDX-License-Identifier:GBL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract constructr {
    constructor(
        address _owner,
        string memory _name,
        uint256 _age
    ) {
        owner = _owner;
        name = _name;
        age = _age;
    }
    address public owner;
    uint256 public age;
    string public name;

    // constructor is one time function, which execute only one time during deployemnt of
    // smartcontract on to blockchain
    // use of Constructor -- >>  set value of owner during deployement time
    // set value of time, date, timestamp
    // set specific details of smart contract during deployemnt

    function checkOwner() public view returns (address) {
        return owner;
    }
}
