// SPDX-License-Identifier: MIT-3.0-only
pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import  "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Token is ERC20 {
  IERC20 public token;
  uint256 public depositDeadline;
  uint256 public lockDuration;

  constructor() ERC20("USD Coin", "USDC") {
        _mint(msg.sender, 10000 * 10 ** 18);
  }
}