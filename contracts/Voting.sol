// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    // Structures de données
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
        address proposer;
    }

    // Énumération pour gérer les états du vote
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    // Variables de contrat
    WorkflowStatus public workflowStatus;
    uint public winningProposalId;

    // Mapping pour stocker les votants
    mapping(address => Voter) public voters;

    // Tableau dynamique pour stocker les propositions
    Proposal[] public proposals;

    // Modificateur pour vérifier l'état du vote
    modifier atState(WorkflowStatus _status) {
        require(workflowStatus == _status, "Action not allowed at this stage.");
        _;
    }

    // Modificateur pour vérifier si un votant est enregistré
    modifier isRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "You are not a registered voter.");
        _;
    }

    // Fonction pour réinitialiser le statut de vote d'un électeur.
function resetVoterStatus(address _voterAddress) external onlyOwner {
    require(workflowStatus == WorkflowStatus.VotingSessionEnded || workflowStatus == WorkflowStatus.VotesTallied, "Resetting voter status is not allowed at this stage.");
    require(voters[_voterAddress].isRegistered, "Voter is not registered.");
    
    voters[_voterAddress].hasVoted = false;
    voters[_voterAddress].votedProposalId = 0;
}


    // Fonction pour vérifier si un électeur a déjà voté.
function hasVoterVoted(address _voterAddress) external view returns (bool) {
    require(voters[_voterAddress].isRegistered, "Voter is not registered.");
    return voters[_voterAddress].hasVoted;
}

    // Constructeur du contrat
    constructor() {
        workflowStatus = WorkflowStatus.RegisteringVoters;
    }

    // Fonction pour inscrire un électeur
    function registerVoter(address _voterAddress) public onlyOwner atState(WorkflowStatus.RegisteringVoters) {
        require(!voters[_voterAddress].isRegistered, "Voter already registered.");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    // Fonction pour démarrer la session d'enregistrement des propositions
    function startProposalsRegistration() public onlyOwner atState(WorkflowStatus.RegisteringVoters) {
        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

// Fonction pour enregistrer une proposition.
    function registerProposal(string memory _description) external {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Proposals registration is not allowed at this stage.");
        uint proposalId = proposals.length;
        proposals.push(Proposal(_description, 0, msg.sender));
        emit ProposalRegistered(proposalId);
    }
    // Fonction pour clôturer la session d'enregistrement des propositions
    function endProposalsRegistration() public onlyOwner atState(WorkflowStatus.ProposalsRegistrationStarted) {
        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

    

    // Fonction pour démarrer la session de vote
    function startVotingSession() public onlyOwner atState(WorkflowStatus.ProposalsRegistrationEnded) {
        workflowStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }


        // Fonction pour voter pour une proposition (marche pas)
    function vote(uint _proposalId) public isRegisteredVoter atState(WorkflowStatus.VotingSessionStarted) {
        require(_proposalId < proposals.length, "Invalid proposal ID.");
        require(!voters[msg.sender].hasVoted, "You have already voted.");
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;
        emit Voted(msg.sender, _proposalId);
    }

    // Fonction pour clôturer la session de vote (a voir)
    function endVotingSession() public onlyOwner atState(WorkflowStatus.VotingSessionStarted) {
        workflowStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }



    // Fonction pour clôturer la session de vote et déterminer le gagnant
    function closeVotingSession() public onlyOwner atState(WorkflowStatus.VotingSessionEnded) {
        workflowStatus = WorkflowStatus.VotesTallied;
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    // Fonction pour obtenir le gagnant
    function getWinner() public view returns (uint) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Voting is not yet closed.");
        return winningProposalId;
    }



    // Événements
    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);


    // Ajoutez une nouvelle structure de données pour stocker les votes contre chaque proposition
struct RejectedVote {
    bool isRejected;
    uint voteCount;
}

// Mapping pour stocker les votes rejetés
mapping(uint => RejectedVote) public rejectedVotes;

// Fonction pour voter contre une proposition
function voteAgainst(uint _proposalId) public isRegisteredVoter atState(WorkflowStatus.VotingSessionStarted) {
    require(_proposalId < proposals.length, "Invalid proposal ID.");
    require(!voters[msg.sender].hasVoted, "You have already voted.");
    voters[msg.sender].hasVoted = true;
    voters[msg.sender].votedProposalId = _proposalId;
    rejectedVotes[_proposalId].isRejected = true;
    rejectedVotes[_proposalId].voteCount++;
    emit Voted(msg.sender, _proposalId);
}

  // Fonction pour obtenir l'adresse du proposant d'une proposition
    function getProposerAddress(uint _proposalId) public view returns (address) {
        require(_proposalId < proposals.length, "Invalid proposal ID.");
        return proposals[_proposalId].proposer;
    }


}