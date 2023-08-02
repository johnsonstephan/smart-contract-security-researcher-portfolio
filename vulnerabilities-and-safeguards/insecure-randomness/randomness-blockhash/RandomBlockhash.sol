/** 
@title RandomBlockhash (Randomness Vulnerabilities Exercise)
@notice This contract generates a pseudo-random number game based on Ethereum blockhash. It tracks wins in a row and sends a reward after 10 consecutive wins.
@dev Based on Ethereum's blockhash for randomness, which is predictable and thus insecure for important randomness needs.

Objectives: 
(a) Map player addresses to their consecutive wins.
(b) Have a constructor to initialize the contract.
(c) Include a play function where users can guess the outcome of a random event, tracked through the Ethereum blockhash.
(d) Restrict users to only one play per block.
(e) Keep track of the last used blockhash to prevent multiple games in the same block.
(f) Reward players who win 10 times consecutively.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract RandomBlockhash {

    /// @custom:objective (a) Map player addresses to their consecutive wins
    /// @dev Mapping from player's address to their consecutive wins
    mapping(address => uint) public players;

    /// @dev Last blockhash value used in the play function, to ensure only one play per block
    uint256 lastValue;

    /// @dev Constant value representing the minimum wins in a row needed to get the reward
    uint8 constant CONSECUTIVE_WINS = 10;

    /// @custom:objective (b) Have a constructor to initialize the contract
    /// @notice Initializes the RandomBlockhash contract
    constructor() payable {}

    /// @custom:objective (c) Include a play function where users can guess the outcome of a random event
    /// @notice Play the game by guessing the outcome of the blockhash
    /// @dev If the guess is correct, increments the player's wins count; resets otherwise
    /// @param _guess Player's guess (true or false)
    function play(bool _guess) external payable {
        
        /// @dev Require 1 ETH to play the game
        require(msg.value == 1 ether, "1 ETH required to play the game!");

        /// @custom:objective (d) Restrict users to only one play per block
        /// @notice Compute a uint representation of the previous block hash
        /// @dev If the block is the same as the last played, revert the transaction
        uint256 value = uint256(blockhash(block.number - 1));
        require(lastValue != value, "Only one play per block!");
        lastValue = value;

        /// @dev Generate a random number from the blockhash, and derive a boolean answer
        uint256 random = value % 2;
        bool answer = random == 1 ? true : false;

        /// @notice If the guess is correct, increments the player's wins count; resets otherwise
        if (answer == _guess) {

            players[msg.sender]++;

            /// @custom:objective (f) Reward players who win 10 times consecutively
            /// @notice If the player wins 10 times in a row, send them all the contract balance and reset their wins
            if(players[msg.sender] == CONSECUTIVE_WINS) {
                (bool sent, ) = msg.sender.call{value: address(this).balance}("");
                require(sent, "Failed to send Ether");
                players[msg.sender] = 0;
            }
        } else {
            players[msg.sender] = 0;
        }
    }
}
