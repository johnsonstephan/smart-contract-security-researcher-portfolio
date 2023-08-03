/*
@title TimedVaultOverflowFixed
@notice This contract allows users to deposit ETH, lock it for a specified duration and withdraw it after the lock duration has expired.
@dev Built with Solidity ^0.8.0.

Objectives: 
(a) Offer a solution to the overflow vulnerability, by updating the solidity version to ^0.8.0

This solution works because the Solidity compiler version ^0.8.0 has a new feature that prevents integer overflows and underflows.

*/

// SPDX-License-Identifier: MIT
// @custom:objective (a) Update the solidity version to ^0.8.0
pragma solidity ^0.8.0;

/**
 * @notice This contract allows a user to deposit ETH, set a lock time for their deposit, increase the lock time, and withdraw the deposit after lock time has expired.
 */
contract TimedVaultOverflowFixed {

    mapping(address => uint) public getBalance;

    mapping(address => uint) public getLocktime;

    // @dev Initialize the contract
    constructor() {}

    /**
     * @notice Function to deposit ETH into the contract
     * @dev When the user deposits ETH, their balance is updated and their funds are locked for 60 days
     */
    function depositETH() public payable {
        getBalance[msg.sender] += msg.value;
        getLocktime[msg.sender] = block.timestamp + 60 days;
    }

    /**
     * @notice Function to increase the lock time for a user's deposit
     * @dev The user specifies the number of seconds to increase their lock time by
     * @param _secondsToIncrease The number of seconds to increase the lock time by
     */
    function increaseMyLockTime(uint _secondsToIncrease) public {
        getLocktime[msg.sender] += _secondsToIncrease;
    }

    /**
     * @notice Function for a user to withdraw their deposit
     * @dev The user can only withdraw their deposit after their lock time has expired
     */
    function withdrawETH() public {
        require(getBalance[msg.sender] > 0);
        require(block.timestamp > getLocktime[msg.sender]);

        uint transferValue = getBalance[msg.sender];

        getBalance[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: transferValue}("");
        require(sent, "Failed to send ETH");
    }
}
