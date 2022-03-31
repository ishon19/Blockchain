// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

contract AccountsDemo {
    address public whoDeposited;
    uint public depositAmt;
    uint public balance;

    function deposit() public payable {
        whoDeposited = msg.sender;
        depositAmt = msg.value;
        balance = address(this).balance;
    }
}