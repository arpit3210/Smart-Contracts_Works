// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

// Data Types = Values and References


// values-- bool. uint, bytes, address
// refernce - array
contract dataTypes_values
{

bool public booltemp= true;
uint8 public temp= 2;   //uint8, uint16, uint32, uint64
bytes32 public cool;
address public add= msg.sender;

}


// For uint8 (8-bit), the maximum value is 2^8 - 1 = 255. >> 255: 11111111
//    11111111 this thing shows the value of bits = 8 bits
// thats why we write >>>   uint8
//Examples= 
//uint8 b1=255;  right
//uint8 b1=234;  right
//uint8 b1=135;  wrong
//uint8 b1=256;  wrong


//For uint16 (16-bit), the maximum value is 2^16 - 1 = 65,535.
//For uint32 (32-bit), the maximum value is 2^32 - 1 = 4,294,967,295.
//For uint64 (64-bit), the maximum value is 2^64 - 1 = 18,446,744,073,709,551,615.

//255: 11111111
//The binary representation of the decimal value 18,446,744,073,709,551,615 is:
//    1111111111111111111111111111111111111111111111111111111111111111




//  Bytes32 - stored fixed length of data into it.   bit size for this 256 bits
//  32 bytes 
//  1 byte = 8 bit
//  32 bytes * 8 = 256 bits