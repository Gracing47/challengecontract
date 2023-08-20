// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ChallengeContract is Ownable {
    // Struktur für Bedingungen
    struct Condition {
        string description;
        uint256 amount;
        bool completed;
    }

    // Struktur für Challenges
    struct Challenge {
        uint256 id;
        address challenger;
        string description;
        Condition[] conditions;
        uint minConditions;
        uint maxConditions;
        bool open;
        address winner;
        address runnerUp;
    }

    mapping (uint256 => Challenge) public challenges;

    mapping (uint256 => address) public referrals;

    uint256 public minimumStake = 1 * 10**18;

    uint256 public currentChallengeId = 0;

    event ChallengeCreated(uint256 indexed challengeId, address indexed creator, string description);

    event ChallengeAccepted(uint256 indexed challengeId, address indexed participant);

    event ConditionCompleted(uint256 indexed challengeId, address indexed participant, uint conditionIndex);

    event ChallengeCompleted(uint256 indexed challengeId, address indexed winner, address indexed runnerUp);

    // Funktion zum Erstellen einer neuen Challenge
    function createChallenge(string memory _description, Condition[] memory _conditions, uint _minConditions, uint _maxConditions) public payable {
        require(msg.value >= minimumStake, "Insufficient stake");
        require(_conditions.length >= _minConditions && _conditions.length <= _maxConditions, "Invalid no. of conditions");

        // Neue Challenge erstellen und speichern
        challenges[currentChallengeId].id = currentChallengeId;
        challenges[currentChallengeId].challenger = msg.sender;
        challenges[currentChallengeId].description = _description;
        challenges[currentChallengeId].minConditions = _minConditions;
        challenges[currentChallengeId].maxConditions = _maxConditions;
        challenges[currentChallengeId].open = true;
        challenges[currentChallengeId].winner = address(0);
        challenges[currentChallengeId].runnerUp = address(0);

        // Bedingungen manuell kopieren
        for (uint i = 0; i < _conditions.length; i++) {
            challenges[currentChallengeId].conditions.push(
                Condition({
                    description: _conditions[i].description,
                    amount: _conditions[i].amount,
                    completed: false
                })
            );
        }

        // Event auslösen und Challenge-ID inkrementieren
        emit ChallengeCreated(currentChallengeId, msg.sender, _description);
        currentChallengeId++;
    }

    // Funktion zum Annehmen einer Challenge
    function acceptChallenge(uint256 _challengeId) public payable {
        require(msg.value >= minimumStake);
        
        // Teilnehmer hinzufügen, wenn Challenge offen ist
        challenges[_challengeId].open = false;
        challenges[_challengeId].runnerUp = msg.sender;

        emit ChallengeAccepted(_challengeId, msg.sender);
    }

    // Funktion zum Abschließen einer Bedingung
    function completeCondition(uint256 _challengeId, uint _conditionIndex) public {
        // Prüfe, ob Status offen ist und der Absender entweder Challenger oder RunnerUp ist
        require(
            challenges[_challengeId].open == true &&
            (msg.sender == challenges[_challengeId].challenger || msg.sender == challenges[_challengeId].runnerUp),
            "Only challenger or runner up can complete conditions"
        );
        
        // Bedingung als erledigt markieren
        challenges[_challengeId].conditions[_conditionIndex].completed = true;

        emit ConditionCompleted(_challengeId, msg.sender, _conditionIndex);
    }

    // Funktion zum Schließen einer Challenge
    function closeChallenge(uint256 _challengeId) public {
        // Ermittle und bezahle Gewinner und Zweitplatzierte, setze Status geschlossen
        address winner = determineWinner(_challengeId);
        challenges[_challengeId].winner = winner;
        challenges[_challengeId].open = false;

        emit ChallengeCompleted(_challengeId, winner, challenges[_challengeId].runnerUp);
    }

    // Funktion zur Ermittlung des Gewinners einer Challenge
    function determineWinner(uint256 _challengeId) internal view returns (address) {
        uint challengerCompleted = 0;
        uint runnerUpCompleted = 0;

        // Anzahl der erfüllten Bedingungen für jeden Teilnehmer zählen
        for (uint i = 0; i < challenges[_challengeId].conditions.length; i++) {
            if (challenges[_challengeId].conditions[i].completed) {
                challengerCompleted++;
            } else {
                runnerUpCompleted++;
            }
        }

        // Gewinner basierend auf den meisten erfüllten Bedingungen auswählen
        return (challengerCompleted >= runnerUpCompleted) ? challenges[_challengeId].challenger : challenges[_challengeId].runnerUp;
    }
}
