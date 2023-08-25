/*
@title CryptoBankSecured (Secured Bank Contract)
@notice This contract is a secured version of the previous CryptoBank contract, with updates to patch the reentrancy vulnerability in the withdrawETH function. 
@dev The contract aims to handle Ether deposits and withdrawals securely, with mechanisms to prevent reentrancy attacks. 

Objectives: 
(a) Import the ReentrancyGuard contract from OpenZeppelin for reentrancy protection.
(b) Create a mutex lock and implement it within a custom modifier to prevent reentrancy.
(c) Utilize OpenZeppelin's ReentrancyGuard and a custom modifier to secure the withdrawETH function.
(d) Follow the Check-Effects-Interaction (CEI) pattern to minimize the potential for errors.

Solution: 
- The contract is designed to avoid reentrancy attacks by implementing OpenZeppelin's ReentrancyGuard and a custom mutex lock.
- It also follows the CEI pattern to avoid unexpected behavior during the withdrawal of Ether.

Explanation:
- Vulnerability exists when contracts don’t properly handle external calls that could execute unknown code.
- By using ReentrancyGuard and following the CEI pattern, the contract ensures that no recursive calls can be made, thus avoiding potential reentrancy attacks.

SECURITY CHANGELOG: 
(I) The contract withdrawETH() function has been updated to follow the CEI pattern (checks-effects-interactions).
(II) A mutex lock has been added to the contract.
(III) Utilize OZ's ReentrancyGuard contract to prevent reentrancy.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// @custom:objective (a) Import the ReentrancyGuard contract from OpenZeppelin
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// @custom:objective (c) Utilize OpenZeppelin's ReentrancyGuard contract to prevent reentrancy
contract CryptoBankSecured is ReentrancyGuard {

    mapping(address => uint256) public balances; // Mapping to track user balances

    // @custom:objective (b) Create a mutex lock to prevent reentrancy (it will default to false)
    bool private locked; // Security Update (II): Mutex lock for preventing reentrancy

    // @custom:objective (b) Create the modifier to prevent reentrancy
    modifier noReentrancy() {
        require(!locked, "No reentrancy"); // Security Update (II): Check for mutex lock
        locked = true;
        _;
        locked = false; // Security Update (II): Release mutex lock
    }

    // Function to deposit ETH
    function depositETH() public payable {
        // Objective: Increment the sender's balance with the deposited amount
        balances[msg.sender] += msg.value;
    }

    // @custom:objective (c) Update the withdrawETH() function to include the OZ ReentrancyGuard and custom noReentrancy modifier
    // Function to withdraw ETH following CEI pattern
    function withdrawETH() public nonReentrant noReentrancy { // Security Update (III): Include ReentrancyGuard and custom noReentrancy modifier
        // @custom:objective (d) We will update the contract in order to secure it via the CEI method

        // Objective: Set a variable to the balance of the sender
        uint256 balance = balances[msg.sender];

        // Objective (d): CHECK that the balance is greater than 0
        require(balance > 0, "Balance must be greater than 0"); // Security Update (I): Check part of the CEI pattern
        
        // Objective (d): EFFECT: Update the state; update the balance
        balances[msg.sender] = 0; // Security Update (I): Effect part of the CEI pattern

        // Objective (d): INTERACTION: Send ETH 
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Withdraw failed"); // Security Update (I): Interaction part of the CEI pattern
    }
}
