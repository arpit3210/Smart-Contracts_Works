// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DAOMembership {
    address public owner;
    mapping(address => bool) public members;
    mapping(address => bool) public applicants;
    mapping(address => mapping(address => bool))
        public applicantsVote_approvals;
    mapping(address => uint256) public vote;
    uint256 public memberCount;

    constructor() {
        owner = msg.sender;
        members[msg.sender] = true;
        memberCount = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    modifier notMember() {
        require(!members[msg.sender], "Already a member");
        _;
    }

    modifier validApplicant(address _applicant) {
        require(applicants[_applicant], "Invalid applicant");
        _;
    }

    function applyForEntry() public notMember {
        require(
            !applicants[msg.sender],
            "you already applied to beacome a member of dao"
        );
        applicants[msg.sender] = true;
    }

    function approveEntry(address _applicant)
        public
        onlyMember
        validApplicant(_applicant)
    {
        require(
            !applicantsVote_approvals[msg.sender][_applicant],
            "Already Voted for this applicant"
        );
        uint256 requiredApprovals = (memberCount * 30) / 100 + 1;

        applicantsVote_approvals[msg.sender][_applicant] = true;
        vote[_applicant]++;
        uint256 approvals = vote[_applicant];

        // require(approvals >= requiredApprovals, "Not enough approvals");
        // members[_applicant] = true;
        // applicants[_applicant] = false;
        // memberCount++;

        if (approvals >= requiredApprovals) {
            members[_applicant] = true;
            applicants[_applicant] = false;
            memberCount++;
        }
    }

    function isMember(address _user) public view onlyMember returns (bool) {
        return members[_user];
    }

    function totalMembers() public view onlyMember returns (uint256) {
        return memberCount;
    }
}
