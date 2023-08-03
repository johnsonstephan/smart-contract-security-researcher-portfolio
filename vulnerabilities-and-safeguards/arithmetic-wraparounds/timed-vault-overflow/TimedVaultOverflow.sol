/*
@title TimedVaultOverflow (Time-lock Contract)
@notice This contract allows users to deposit ETH, lock it for a specified duration and withdraw it after the lock duration has expired.
@dev Built with Solidity ^0.7.0.

Objectives: 
(a) Implement a time-lock mechanism where deposited funds are locked for a certain duration.
(b) Have a function to increase the lock time for a user's deposit.
(c) Prevent a user from withdrawing their deposit until the lock duration has expired.


Solution/Expliot:
An attacker can exploit this vulnerability by calling the increaseMyLockTime function with a large number that causes an integer overflow, wrapping the lock time around to a low number. 
The user can then immediately call the withdrawETH function and retrieve their deposited ETH even before the actual lock time has passed. 

Explanation:
In Solidity, numbers are represented as unsigned integers (uint) which have a maximum limit. 
If an operation results in a number greater than this limit, the number wraps around to start from zero. 
This is known as an integer overflow. 

In this contract, the increaseMyLockTime function is vulnerable to such an overflow. 
A user (or an attacker) can call this function with a very high number that causes the lock time to exceed the maximum limit of uint. 
As a result, the lock time wraps around to start from zero. 
This allows the user to withdraw their deposited ETH immediately by calling the withdrawETH function, thus bypassing the intended time lock mechanism. 

Steps to hack the contract:
1. Deposit ETH into the contract using the depositETH function.
2. Call the increaseMyLockTime function with a very high number to trigger the integer overflow.
3. Immediately call the withdrawETH function to retrieve the deposited ETH.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

/**
 * @notice This contract allows a user to deposit ETH, set a lock time for their deposit, increase the lock time, and withdraw the deposit after lock time has expired.
 */
contract TimedVaultOverflow {

    // @custom:objective (a) Create a mapping to hold user balances
    mapping(address => uint) public getBalance;

    // @custom:objective (a) Create a mapping to hold lock times for each user
    mapping(address => uint) public getLocktime;

    // @dev Initialize the contract
    constructor() {}

    /**
     * @notice Function to deposit ETH into the contract
     * @dev When the user deposits ETH, their balance is updated and their funds are locked for 60 days
     */
    function depositETH() public payable {
        // @custom:objective (a) Update the user balance
        getBalance[msg.sender] += msg.value;
        // @custom:objective (a) Update the lock time for the user
        getLocktime[msg.sender] = block.timestamp + 60 days;
    }

    /**
     * @notice Function to increase the lock time for a user's deposit
     * @dev The user specifies the number of seconds to increase their lock time by
     * @param _secondsToIncrease The number of seconds to increase the lock time by
     */
    function increaseMyLockTime(uint _secondsToIncrease) public {
        // @custom:objective (b) Increase the lock time for the user
        getLocktime[msg.sender] += _secondsToIncrease;
    }

    /**
     * @notice Function for a user to withdraw their deposit
     * @dev The user can only withdraw their deposit after their lock time has expired
     */
    function withdrawETH() public {
        // @custom:objective (c) Ensure the user has a balance to withdraw
        require(getBalance[msg.sender] > 0);
        // @custom:objective (c) Ensure the lock time for the user has expired
        require(block.timestamp > getLocktime[msg.sender]);

        // @custom:objective (c) Store the amount to transfer in a temporary variable
        uint transferValue = getBalance[msg.sender];

        // @custom:objective (c) Reset the user balance to 0
        getBalance[msg.sender] = 0;

        // @custom:objective (c) Attempt to transfer the funds to the user
        (bool sent, ) = msg.sender.call{value: transferValue}("");
        // @custom:objective (c) Ensure the funds were successfully transferred
        require(sent, "Failed to send ETH");
    }
}
