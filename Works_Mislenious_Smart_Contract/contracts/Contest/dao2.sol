// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DAOMembership {

    //To apply for membership of DAO
    function applyForEntry() public {}
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public {}

    //To disapprove the applicant for membership of DAO
    function disapproveEntry(address _applicant) public{}

    //To remove a member from DAO
    function removeMember(address _memberToRemove) public {}

    //To leave DAO
    function leave() public {}

    //To check membership of DAO
    function isMember(address _user) public view returns (bool) {}

    //To check total number of members of the DAO
    function totalMembers() public view returns (uint256) {}
}
