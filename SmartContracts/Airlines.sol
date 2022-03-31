// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

contract Airlines {
    address chairperson;
    struct details {
        uint escrow;
        uint status;
        uint hashOfDetails;    
    }

    mapping(address => details) public balanceDetails;
    mapping(address => uint) membership;

    // list of modifiers or the rules

    // no params
    modifier onlyChairperson {
        require(msg.sender == chairperson);
        _;
    }
    
    // no params in the modifiers
    modifier onlyMember {
        require(membership[msg.sender]==1);
        _;
    }

    // define the constructor
    constructor() public payable {
      chairperson = msg.sender;
      membership[msg.sender] = 1;
      balanceDetails[msg.sender].escrow = msg.value;
    }

    function register() public payable {
        address addr = msg.sender;
        membership[addr] = 1;
        balanceDetails[msg.sender].escrow = msg.value;
    }

    function unregister(address payable airline) onlyChairperson public {
        if(chairperson!=msg.sender) revert();
        membership[airline] = 0;
        // give the amount which this airline had back to them 
        airline.transfer(balanceDetails[airline].escrow);
        balanceDetails[airline].escrow = 0;
    }

    function request(address toAirline, uint hashOfDetails) onlyMember public {
        if(membership[toAirline]!=1) revert();
        balanceDetails[msg.sender].status = 0;
        balanceDetails[msg.sender].hashOfDetails = hashOfDetails; 
    }

    function response(address fromAirline, uint hashOfDetails, uint done) onlyMember public {
        if(membership[fromAirline]!=1) revert();
        balanceDetails[msg.sender].status = 0;
        balanceDetails[msg.sender].hashOfDetails = hashOfDetails;
    }

    function settlePayment(address payable to) onlyMember payable public {
        address from = msg.sender;
        uint amt = msg.value;
        balanceDetails[to].escrow += amt;
        balanceDetails[from].escrow -= amt;

        // send the amount
        to.transfer(amt);
    }
}