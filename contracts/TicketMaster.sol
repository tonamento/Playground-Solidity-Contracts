// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TicketMaster {
    address public owner;
    IERC20 public usdc;

    uint256 public ticketBuyRate; // 1 USDC = ticketBuyRate TOTO
    uint256 public ticketSellRate; // 1 USDC = ticketSellRate TOTO
    bool public pause; 

    mapping(address => uint256) public tickets;

    event TicketPurchased(address indexed buyer, uint256 amount);
    event TicketSold(address indexed seller, uint256 amount);
    event TicketUsed(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    modifier openTrade() {
        require(!pause, "Operation is paused.");
        _;
    }

    constructor(address _usdcAddress, uint256 _buyRate, uint256 _sellRate) {
        owner = msg.sender;
        usdc = IERC20(_usdcAddress);
        ticketBuyRate = _buyRate;
        ticketSellRate = _sellRate;
    }

    function buyTicket(uint256 _usdcAmount) external openTrade returns (bool) {
        require(usdc.balanceOf(msg.sender) >= _usdcAmount, 'Insufficient USDC balance');
        require(usdc.allowance(msg.sender, address(this)) >= _usdcAmount, 'Insufficient allowance');

        uint256 costInTokens = _usdcAmount * ticketBuyRate;
        require(usdc.transferFrom(msg.sender, address(this), _usdcAmount), "Transfer of USDC failed");

        tickets[msg.sender] += costInTokens; 
        emit TicketPurchased(msg.sender, costInTokens);
        return true;
    }

    function sellTicket(uint256 _tokensAmount) external openTrade returns (bool) {
        require(tickets[msg.sender] >= _tokensAmount, 'Insufficient ticket balance');

        uint256 amountInUSDC = _tokensAmount / ticketSellRate;
        require(usdc.transfer(msg.sender, amountInUSDC), "Transfer of USDC failed");
        
        tickets[msg.sender] -= _tokensAmount;
        emit TicketSold(msg.sender, amountInUSDC);
        return true;
    }

    function useTicket(uint256 _tokensAmount) external openTrade returns (bool) {
        require(tickets[msg.sender] >= _tokensAmount, 'Insufficient ticket balance');
        tickets[msg.sender] -= _tokensAmount;
        emit TicketUsed(msg.sender, _tokensAmount);
        return true;
    }

     function pauseTrade() public onlyOwner {
        pause = true;
    }

    function unauseTrade() public onlyOwner {
        pause = false;
    }
}
