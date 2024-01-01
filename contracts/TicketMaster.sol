// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TicketMaster {
    address public _owner;
    IERC20 public _usdc;

    uint256 public _ticketBuyRate; // 1 USDC = _ticketBuyRate TOTO
    uint256 public _ticketSellRate; // 1 USDC = _ticketSellRate TOTO
    bool public _pause; 

    mapping(address => uint256) public _tickets;
    mapping(address => bool) public _blacklist;

    event TicketPurchased(address indexed buyer, uint256 amount);
    event TicketSold(address indexed seller, uint256 amount);
    event TicketUsed(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract _owner can call this function.");
        _;
    }

    modifier openTrade() {
        require(!_pause, "Operation is paused.");
        _;
    }

    modifier notBlacklisted () {
        require(msg.sender != address(0), "Invalid address.");
        require(!_blacklist[msg.sender], "Blacklisted address.");
        _;
    }

    constructor(address _usdcAddress, uint256 _buyRate, uint256 _sellRate) {
        _owner = msg.sender;
        _usdc = IERC20(_usdcAddress);
        _ticketBuyRate = _buyRate;
        _ticketSellRate = _sellRate;
    }

    function buyTicket(uint256 _usdcAmount) external openTrade notBlacklisted returns (bool) {
        require(_usdc.balanceOf(msg.sender) >= _usdcAmount, 'Insufficient USDC balance');
        require(_usdc.allowance(msg.sender, address(this)) >= _usdcAmount, 'Insufficient allowance');

        uint256 costInTokens = (_usdcAmount * _ticketBuyRate) / 1e18; // 1e18 is used for precision
        require(_usdc.transferFrom(msg.sender, address(this), _usdcAmount), "Transfer of USDC failed");

        _tickets[msg.sender] += costInTokens; 
        emit TicketPurchased(msg.sender, costInTokens);
        return true;
    }

    function sellTicket(uint256 _tokensAmount) external openTrade notBlacklisted returns (bool) {
        require(_tickets[msg.sender] >= _tokensAmount, 'Insufficient ticket balance');

        uint256 amountInUSDC = (_tokensAmount / _ticketSellRate) * 1e18; // 1e18 is used for precision
        require(_usdc.transfer(msg.sender, amountInUSDC), "Transfer of USDC failed");

        _tickets[msg.sender] -= _tokensAmount;
        emit TicketSold(msg.sender, amountInUSDC);
        return true;
    }

    function useTicket(uint256 _tokensAmount) external openTrade notBlacklisted returns (bool) {
        require(_tickets[msg.sender] >= _tokensAmount, 'Insufficient ticket balance');
        _tickets[msg.sender] -= _tokensAmount;
        emit TicketUsed(msg.sender, _tokensAmount);
        return true;
    }

    function withdraw(address recipient) external onlyOwner openTrade {
        require(_tickets[msg.sender] > 0, "No _usdc to withdraw");
        uint256 amountInUSDC = _usdc.balanceOf(address(this)); // 1e18 is used for precision
        require(_usdc.transfer(recipient, amountInUSDC), "Transfer of USDC failed");
    }

    function freezeTickets(address recipient) external onlyOwner {
        _tickets[recipient] = 0;
    }

    function blacklist(address recipient) external onlyOwner {
        _blacklist[recipient] = true;
    }

    function unblacklist(address user) external onlyOwner {
        _blacklist[user] = false;
    }

    function pauseTrade() public onlyOwner {
        _pause = true;
    }

    function unauseTrade() public onlyOwner {
        _pause = false;
    }
}
