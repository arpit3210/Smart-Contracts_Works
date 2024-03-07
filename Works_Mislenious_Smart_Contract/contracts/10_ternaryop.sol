// SPDX-License-Identifier: GBL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract ternary {
    // ternary operator is replacement of if else statement
    // ternary operator code is one liner code easy to use  and understandable

    function checkvalue(uint256 x) public pure returns (string memory) {
        if (x > 100) {
            return "greater than 100";
        } else {
            return "equal or lesser than 100";
        }
    }

    function TernaryCheckValue(uint256 x) public pure returns (string memory) {
        string memory val;
        val = x > 100 ? "greater than 100" : "Equal and smaller than 100";
        // val= statement ? "true": "false";
        return val;
    }

bool public TicketBooked;

function BookTicketandUnBookTicket() public {
    TicketBooked = !TicketBooked;
}


// bool public TicketBooked;

// function BookTicketandUnBookTicket() public 
// {
//     if(TicketBooked == false)
//     {
// TicketBooked= true;
//     }
//     else if (TicketBooked==true)
//     {
//         TicketBooked = false;
//     }
//     else {
//         TicketBooked= true;
//     }
// }



function TerbarywithBool(bool _TicketBooked) public view returns(bool)
{
    bool val;
   
    val= keccak256(abi.encodePacked(TicketBooked ))== keccak256(abi.encodePacked(_TicketBooked)) ? true: false;
     return val;
}





// How to compare two strings with ternary operator
// using keccak256 algoritham
    function Ternarycheck(string memory pass2) public pure returns (string memory)
    {
        
        string memory pass1="jdsfhk";
        string memory val;
           val= keccak256(abi.encodePacked(pass1)) == keccak256(abi.encodePacked(pass2)) ? "YOU can use this account ": "YOU have not permission ";
           return val;

    }
}

// above code work is same but one use of simple if else other one with Ternary operator
