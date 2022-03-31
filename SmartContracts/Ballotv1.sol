// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

contract BallotV1 {
    struct voter {
        uint weight;
        bool voted;
        uint vote;
    }

    struct proposal {
        uint voteCount;
    }

    address chairperson;
    mapping(address => voter) voters;
    proposal[] proposals;

    enum Phase {Init, Regs, Vote, Done}
    Phase public state = Phase.Init;

    // adding the modifiers here
    modifier validPhase(Phase phase) {
        require(state == phase);
        _;
    }

    modifier onlyChair() {
        require(msg.sender == chairperson);
    }

    constructor(uint numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        for(uint prop = 0; prop<numProposals; prop++) {
            proposals.push(proposal(0));
        }
    }

    function changeState(Phase x) public onlyChair {
      // with no modifier we can explicitly check like this
      // if(msg.sender != chairperson || x < state) revert();
      require(x > state);
      state = x;
    }

    function register(address newVoter) public validPhase(Phase.Regs) onlyChair {
        // if(msg.sender != chairperson || voters[newVoter].voted) revert();
        require(!voters[newVoter].voted);
        voters[newVoter].weight = 1;
        // voters[newVoter].voted = false;
    }

    function vote(uint toProposal) public validPhase(Phase.Vote) {
        voter memory sender = voters[msg.sender];
        // if(sender.voted || toProposal>= proposals.length) revert();
        require(!sender.voted);
        require(toProposal < proposals.length);
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) {
        uint count = 0;
        for(uint i=0; i<proposals.length; i++) {
            if(proposals[i].voteCount > count) {
                count = proposals[i].voteCount;
                winningProposal = i;
            }
        }
        assert(winningVoteCount>=3);
    }
}