/*
@title CryptoBank (A Simple Bank Contract)
@notice This contract allows users to deposit and withdraw ETH. 
@dev It showcases how mapping can be used to handle users' balances but lacks proper security considerations.

Objectives:
(a) Allow users to deposit ETH into the contract.
(b) Allow users to withdraw their entire ETH balance from the contract.
(c) Provide a clear example of a contract that is vulnerable to reentrancy attacks.

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract CryptoBank {

    // Mapping to track user balances. Key is the user's address, value is the amount of ETH.
    mapping(address => uint256) public balances;

    /**
     * @notice Deposit ETH into the contract. The sent value is added to the sender's balance.
     * @custom:objective (a) Allow users to deposit ETH into the contract.
     */
    function depositETH() public payable {
        // Add the sent value to the user's balance
        balances[msg.sender] += msg.value;
    }

    /**
     * @notice Withdraw the entire balance for the sender from the contract. The balance is sent to the sender's address.
     * @dev This function is vulnerable to reentrancy attacks as it first sends the balance and then updates it.
     * @custom:objective (b) Allow users to withdraw their entire ETH balance from the contract.
     * @custom:objective (c) Provide a clear example of a contract that is vulnerable to reentrancy attacks.
     */
    function withdrawETH() public {
        // Get the user's balance
        uint256 balance = balances[msg.sender];

        // Send ETH to the user's address
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "The withdraw failed."); // Ensure the transfer was successful

        // Update the user's balance to zero
        balances[msg.sender] = 0;
    }
}
