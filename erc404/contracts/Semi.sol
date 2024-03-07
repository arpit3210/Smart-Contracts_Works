//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";

contract Semi is ERC404 {
  constructor() ERC404("Semi Fungible Token", "SEMI", 18) {
    _setERC721TransferExempt(msg.sender, true);
    _mintERC20(msg.sender, 10000 * units);
  }

  function tokenURI(uint256 id_) public pure override returns (string memory) {
    return string.concat("https://jamesbachini.com/", Strings.toString(id_));
  }

}