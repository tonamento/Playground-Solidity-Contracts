// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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

    function buyingTicket(address _buyer, uint128 _amount) external returns (bool) {
        IERC20 usdc = IERC20(0x43B341FBAE05D3Bfa351362d11783347E184050d);
        require(usdc.balanceOf(_buyer) > _amount , 'Insufficient balance');
        bool transfer = usdc.transferFrom(msg.sender, address(this), _amount);
        return transfer;
    }
}