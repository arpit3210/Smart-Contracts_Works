// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract statevar
{
// State Variable and use 
// we use state variable out of the function and incide the contract
// declaration of state variable - state variable always declares in side contract and outside of function
// state variable intialize value- value can be initialize with the declaration time and in the contsructor
//  and with in the function as well
// we always try to use minimum statevariable -- because these state var puts on blockchain
uint public salary;

constructor()
{
    salary=1000;   // intialize state var with constructor
}


function resetSalary() public 
{
salary= 0;           // initialize state var with function 
}

function decreaseSalary() public 
{
    salary==1000;
    salary-=300;
}

function GetSalry() public view returns(uint)
{
    return salary;
}
}
