// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Voting {
    //Creation de la structure de chaque candidat
    struct Candidate {
        uint256 id;
        string name;
        uint256 numberOfVotes;
    }

    //Listes de tous les candidats
    Candidate[] public candidates;

    //cela contiendra l'adresse du propriétaire
    address public owner;

    //Mapper tous les adresses des electeurs
    mapping(address => bool) public voters;
    //Listes des voteurs
    address[] public listOfVoters;

    //Creation de la session du debut et de la fin de la transaction
    uint256 public votingStart;
    uint256 public votingEnd;

    //Creation de la status de la relation
    bool public electionStarted;

    // Restrindre la creation de l'election au propriétaire
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Vous netes pas autorisez a demarrer une election!"
        );
        _;
    }

    //Verifier que l'election est en cours
    modifier electionOngoing() {
        require(electionStarted, "Les elections n'ont pas encore debuter!");
        _;
    }

    //Creation du constructeur
    constructor() {
        owner = msg.sender;
    }

    // Debuter une election
    function startElection(
        string[] memory _candidates,
        uint256 _votingDuration
    ) public onlyOwner {
        require(electionStarted == false, "L'election est en cours");
        delete candidates;
        resetAllVoterStatus();
        for (uint256 i = 0; i < _candidates.length; i++) {
            candidates.push(
                Candidate({id: i, name: _candidates[i], numberOfVotes: 0})
            );
        }
        electionStarted = true;
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_votingDuration * 1 minutes);
    }

    // Ajouter un nouveau candidat
    function addCandidate(
        string memory _name
    ) public onlyOwner electionOngoing {
        require(checkElectionPeriod(), "La duree des elections est passee");
        candidates.push(
            Candidate({id: candidates.length, name: _name, numberOfVotes: 0})
        );
    }

    //Voir le status des votes
    function voterStatus(
        address _voter
    ) public view electionOngoing returns (bool) {
        if (voters[_voter] == true) {
            return true;
        }
        return false;
    }

    //Fonction pour voter
    function voteTo(uint256 _id) public electionOngoing {
        // require(checkElectionPeriod(), "Les elections sont termines");
        require(
            !voterStatus(msg.sender),
            "Vous avez deja vote, on ne peut voter que une seule fois."
        );
        candidates[_id].numberOfVotes++;
        voters[msg.sender] = true;
        listOfVoters.push(msg.sender);
    }

    //Obtenir de votes

    function retrieveVote() public view returns (Candidate[] memory) {
        return candidates;
    }

    //Afficher  le temps des elections
    function electionTimer() public view electionOngoing returns (uint256) {
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return (votingEnd - block.timestamp);
    }

    //Verifier si les elections sont toujours en cours
    function checkElectionPeriod() public returns (bool) {
        if (electionTimer() > 0) {
            return true;
        }
        electionStarted = false;
        return false;
    }

    //Enlever tous les voters;
    function resetAllVoterStatus() public onlyOwner {
        for (uint256 i = 0; i < listOfVoters.length; i++) {
            voters[listOfVoters[i]] = false;
        }
        delete listOfVoters;
    }
}
