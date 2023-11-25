// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TicketMaster {
    address public owner;
    IERC20 usdc = IERC20(0x43B341FBAE05D3Bfa351362d11783347E184050d);

    uint128 ticketBuyRate = 17.23 ether;
    uint128 ticketSellRate = 17.454 ether;
    
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

    function buyTicket(uint128 _amount) external returns (bool) {
        require(usdc.balanceOf(msg.sender) >= _amount, 'Insufficient balance');
        require(usdc.allowance(msg.sender, address(this)) >= _amount, 'Insufficient allowance');

        uint256 costInTokens = _amount * ticketBuyRate;
        require(usdc.transferFrom(msg.sender, address(this), _amount));
        
        tickets[msg.sender] = costInTokens;
        return true;
    }

    function sellingTicket(uint128 _amount) external returns (bool) {
        require(tickets[msg.sender] >= _amount , 'Insufficient ticket balance');
        require(usdc.transfer(msg.sender, _amount));
        
        tickets[msg.sender] -= _amount * ticketSellRate;
        return true;
    }

     function useTicket(uint128 _amount) external returns (bool) {
        require(usdc.balanceOf(msg.sender) > _amount , 'Insufficient balance');
        tickets[msg.sender] -= _amount;
        return true;
    }
}