// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TicketContract {
    address public owner;
    
    mapping(address => uint) public tickets;

    event TicketPurchased(address indexed buyer, uint amount);
    event TicketUsed(address indexed user, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}