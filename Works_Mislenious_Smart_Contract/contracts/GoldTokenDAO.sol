// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// ERC20 Token Interface
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

//  0xc00e76E2b452dbE1649Bd69F26d6b979E740F1Bf   DAO SMART CONTRACT ADDRESS DEPLOYED ON POLYGON


// Goldy-like DAO Smart Contract
contract GoldyDAO {
    struct Proposal {
        uint256 id;
        address creator;
        string description;
        uint256 votingPowerNeeded;
        uint256 voteCount;
        uint256 startTime;
        uint256 endTime;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public votingPower;
    mapping(address => bool) public isMember;
    address[] public members;
    uint256 public totalMembers;
    
    IERC20 public tokenContract;
    
    constructor(address _tokenContract) {
        tokenContract = IERC20(_tokenContract);
        totalMembers = 0;
    }
    
    modifier onlyMember() {
        require(isMember[msg.sender], "Not a member");
        _;
    }
    
    function joinDAO() external {
        require(!isMember[msg.sender], "Already a member");
        
        // Check if the person has ERC20 tokens
        uint256 balance = tokenContract.balanceOf(msg.sender);
        require(balance > 0, "No tokens to join the DAO");
        
        isMember[msg.sender] = true;
        members.push(msg.sender);
        totalMembers++;
        
        // Set initial voting power to token balance
        votingPower[msg.sender] = balance;
    }
    
    function submitProposal(uint256 proposalId, string memory description, uint256 votingPowerNeeded, uint256 duration) external onlyMember {
        require(proposals[proposalId].id == 0, "Proposal already exists");
        
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + duration;
        
        Proposal storage newProposal = proposals[proposalId];
        newProposal.id = proposalId;
        newProposal.creator = msg.sender;
        newProposal.description = description;
        newProposal.votingPowerNeeded = votingPowerNeeded;
        newProposal.voteCount = 0;
        newProposal.startTime = startTime;
        newProposal.endTime = endTime;
    }
    
    function vote(uint256 proposalId) external onlyMember {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id != 0, "Proposal does not exist");
        require(!proposal.hasVoted[msg.sender], "Already voted");
        require(block.timestamp >= proposal.startTime && block.timestamp <= proposal.endTime, "Voting period has ended");
        
        uint256 balance = votingPower[msg.sender];
        
        proposal.voteCount += balance;
        proposal.hasVoted[msg.sender] = true;
    }
    
    function executeProposal(uint256 proposalId) external onlyMember {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id != 0, "Proposal does not exist");
        require(block.timestamp > proposal.endTime, "Voting period has not ended");
        require(proposal.voteCount >= proposal.votingPowerNeeded, "Votes not enough to pass the proposal");
        
        // Execute the proposal's actions here
        
        // Reset the proposal
        delete proposals[proposalId];
    }
    
    function getVotingPower(address voter) external view returns (uint256) {
        return votingPower[voter];
    }
    
    function getMemberCount() external view returns (uint256) {
        return totalMembers;
    }
}
