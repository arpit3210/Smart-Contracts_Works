// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract loops {
    function Lopp() public pure returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < 12; i = i + 2) {
            count = count + 5;
        }
        return count;
    }

    // Loop also work in function level, does not work at contract level

    function whilelop() public pure returns (uint256) {
        uint256 count = 0;
        uint256 i = 0;
        uint256 n = 5;

        while (i <= n) {
            count = count + 5;
            i += 1;
        }
        return count;
    }

    function dowhilwlop() public pure returns (uint256) {
        uint256 i = 0;
        uint256 n = 5;
        uint256 count = 0;

        do {
            count = count + 5;
            i += 1;
        } while (i <= n);
        return count;
    }
}

contract Example {
    // Use of Continue and break keyword.

    function Loop() public pure returns (uint256) {
        uint256 count = 10;
        uint256 n = 23;
        uint256 i = 3;

        while (i <= n) {
            count = count + 5;
            i += 3;

            if(i == 15 ){
              break;

              //  When we uses break keyword -- after this this left all interations
            }
        }
        return count;
    }


      function Loops() public pure returns (uint256) {
        uint256 count = 10;
        uint256 n = 23;
        uint256 i = 3;

        while (i <= n) {
            count = count + 5;
            i += 3;

            if(i == 15 ){
            continue;

              //  When we uses break keyword -- after this this left all interations
            }
        }
        return count;
    }
}



contract FixedsizeArray{


// FixedSize Array
// we can add more value than limit fixed value
uint[6] public arr = [34,34,34,334685,45,54];


function Valueof_index3() public view returns(uint)
{
    return arr[3];
}

function CHange_index_value(uint indexValue, uint num) public 
{
  arr[indexValue]= num;
  //Update Values
}


function Delete_index_value(uint indexValue) public 
{
    arr[indexValue]= 0;

}

function deletes(uint index) public 
{
    delete arr[index];
        // changed to default value
}


function length_of_array() public view returns(uint)
{
    return arr.length;
}

}
