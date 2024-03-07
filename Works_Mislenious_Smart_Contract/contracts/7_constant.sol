// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract constnt{
constructor()
{

}

// constant -  use where we require constant value till execution of the smart contract 
// Example - Ownership of contract can not change 
// Example-  no of contract users can be limit
// Example - no of token will be limited canstant
// Example - No of Price of Eth transafer can be contant
// It will impact on gascost also if we use this keywords, execution cost will be low

address public constant owner=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;      // gascost= 373 gas

address public owner1=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;         //gascost=	2483 gas
// now we will not be able to change the value of [owner- state var]

}