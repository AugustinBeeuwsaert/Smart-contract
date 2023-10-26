// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    WorkflowStatus public workflowStatus;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);

    function registerVoter(address _voterAddress) public onlyOwner {
        require(
            workflowStatus == WorkflowStatus.RegisteringVoters,
            "Can't register voters at this time."
        );
        require(
            !voters[_voterAddress].isRegistered,
            "The voter is already registered."
        );

        voters[_voterAddress] = Voter({
            isRegistered: true,
            hasVoted: false,
            votedProposalId: 0
        });

        emit VoterRegistered(_voterAddress);
    }

    function startProposalsRegistration() public onlyOwner {
        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;

        emit WorkflowStatusChange(
            WorkflowStatus.RegisteringVoters,
            workflowStatus
        );
    }

    function registerProposal(string memory _description) public {
        require(
            workflowStatus == WorkflowStatus.ProposalsRegistrationStarted,
            "Can't register proposals at this time."
        );
        require(
            voters[msg.sender].isRegistered,
            "Only registered voters can submit proposals."
        );

        proposals.push(Proposal({description: _description, voteCount: 0}));

        emit ProposalRegistered(proposals.length - 1);
    }

    function startVotingSession() public onlyOwner {
        workflowStatus = WorkflowStatus.VotingSessionStarted;

        emit WorkflowStatusChange(
            WorkflowStatus.ProposalsRegistrationEnded,
            workflowStatus
        );
    }

    function vote(uint _proposalId) public {
        require(
            workflowStatus == WorkflowStatus.VotingSessionStarted,
            "Can't vote at this time."
        );
        require(
            voters[msg.sender].isRegistered,
            "Only registered voters can vote."
        );
        require(!voters[msg.sender].hasVoted, "The voter has already voted.");
        require(_proposalId < proposals.length, "Invalid proposal ID.");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;

        proposals[_proposalId].voteCount++;

        emit Voted(msg.sender, _proposalId);
    }

    function endVotingSession() public onlyOwner {
        workflowStatus = WorkflowStatus.VotesTallied;

        emit WorkflowStatusChange(
            WorkflowStatus.VotingSessionEnded,
            workflowStatus
        );
    }

    function getWinner() public view returns (uint winningProposalId) {
        require(
            workflowStatus == WorkflowStatus.VotesTallied,
            "Can't get the winner at this time."
        );

        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }
}