/* 
@title Random Vulnerabilities Guessing (Game Contract)
@notice This contract allows users to guess a pseudo-random number. If the guess is correct, the contract sends the contract's balance to the player.
@dev The contract uses block data to generate pseudo-random numbers which can make it vulnerable to miner attacks.

Objectives: 
(a) Initialize the contract with an ETH balance.
(b) Accepts user guesses for the pseudo-random number.
(c) If the guess is correct, transfer the contract's balance to the guesser.
(d) Handle any failed transfers appropriately.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * @title Random Vulnerabilities Guessing
 * @dev This contract has potential vulnerabilities in its randomness generation.
 * @custom:objective (a) Initialize the contract with an ETH balance
 */
contract RandomVulnerabilitiesGuessing {
    constructor() payable {}

    /**
     * @notice Makes a guess at the pseudo-random number and if correct, wins the contract balance
     * @dev It generates a pseudo-random number using block data, compares with user guess
     * If the guess is correct, it tries to send the contract balance to the user
     * @custom:objective (b) Accepts user guesses for the pseudo-random number
     * @custom:objective (c) If the guess is correct, transfer the contract's balance to the guesser
     * @param guess The number that user guessed
     */
    function play(uint guess) external {
        // Generate a pseudo-random number based on block data
        uint number = uint(keccak256(abi.encodePacked(block.timestamp, block.number, block.difficulty)));

        // If the guess is correct
        if(guess == number) {
            // Try to send the contract's balance to the user
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            // If the send fails, revert the transaction
            // @custom:objective (d) Handle any failed transfers appropriately
            require(sent, "Failed to send ETH");
        }
    }
}