// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BookStore is Ownable {
    using SafeMath for uint256;

    address public bookOwner;

    uint256 public bookPrice;
    uint256 public totalBooksSold;

    mapping(address => uint256) public booksOrdered;

    event BookPurchased(address indexed buyer, uint256 quantity);

    constructor(uint256 _bookPrice) {
        bookOwner = msg.sender;
        bookPrice = _bookPrice;
    }

    modifier onlyBookOwner() {
        require(msg.sender == bookOwner, "Not authorized");
        _;
    }


    function setBookPrice(uint256 _newPrice) external onlyOwner {
        bookPrice = _newPrice;
    }

    function purchaseBook(uint256 _quantity) payable external {
        uint256 totalPrice = bookPrice.mul(_quantity);

        // Ensure the correct amount of Ether is sent
        require(msg.value == totalPrice, "Incorrect Ether value");

        // Increment totalBooksSold
        totalBooksSold = totalBooksSold.add(_quantity);

        // Increment booksOrdered for the buyer's address
        booksOrdered[msg.sender] = booksOrdered[msg.sender].add(_quantity);

        // Emit an event to track the purchase
        emit BookPurchased(msg.sender, _quantity);
    }

    function withdrawEther(uint256 _amount) external onlyBookOwner {
        // Allow the book owner to withdraw Ether from the contract
        require(payable(bookOwner).send(_amount), "Ether transfer failed");
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getBooksOrderedByAddress(address _buyer) external view returns (uint256) {
        return booksOrdered[_buyer];
    }


       function getBooksOrdered() external view returns (uint256) {
        return booksOrdered[msg.sender];
    }
}
