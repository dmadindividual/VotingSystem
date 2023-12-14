// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Voting {
    // Struct representing a proposal with a name and vote count
    struct Proposal {
        string name;
        uint voteCount;
    }
    // Array to store all proposals
    Proposal[] public proposals;

    // Struct representing a voter with their vote choice, voting status, and weight
    struct Voter {
        uint Vote;
        bool Voted;
        uint weight;
    }
    // Mapping of addresses to Voter structs to keep track of voters
    mapping(address => Voter) public voters;

    // Address of the chairman who deploys the contract
    address Chairman;

    // Constructor to initialize the contract with proposal names
    constructor(string[] memory ProposalNames) {
        for (uint i = 0; i < ProposalNames.length; i++) {
            // Initialize each proposal and add it to the proposals array
            proposals.push(Proposal({
                name: ProposalNames[i],
                voteCount: 0
            }));
        }
        // Set the chairman to the address that deploys the contract
        Chairman = msg.sender;
        // Assign a weight of 1 to the chairman
        voters[Chairman].weight = 1;
    }

    // Function allowing the chairman to grant voting rights to a specific address
    function RightToVote(address voter) public {
        require(msg.sender == Chairman, "You are not the chairman");
        require(!voters[voter].Voted, "This Voter has already voted");
        require(voters[voter].weight == 0, "Voter has voted already");
        // Grant voting right by setting the weight to 1
        voters[voter].weight = 1;
    }

    // Function for voters to cast their vote for a specific proposal
    function vote(uint _proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.Voted, "Already Voted");
        // Mark the voter as voted and record their vote choice
        sender.Voted = true;
        sender.Vote = _proposal;
        // Update the vote count for the chosen proposal
        proposals[_proposal].voteCount += sender.weight;
    }

    // Function to determine the index of the winning proposal
    function winningProposals() public view returns (uint _winningProposal) {
        uint winningVote = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVote) {
                winningVote = proposals[i].voteCount;
                // Update the winning proposal index
                _winningProposal = i;
            }
        }
    }

    // Function to get the name of the winning proposal
    function winningName() public view returns (string memory _winnerByName) {
        // Retrieve the name of the winning proposal using the winning proposal index
        _winnerByName = proposals[winningProposals()].name;
    }
}
