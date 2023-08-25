/* 
@title BasicDigitalWallet (A Simple Wallet Contract)
@notice This contract represents a basic digital wallet that allows only the owner to transfer funds.

Objectives: 
(a) Creation of a basic digital wallet contract with an owner.
(b) Implementation of a transfer function, only allowing the wallet's owner to transfer funds.
(c) Usage of the tx.origin to check the origin of the transaction and demonstrate a phishing vulnerability.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract BasicDigitalWallet {
    /// @notice The address of the wallet owner.
    /// @dev Only the owner of the wallet is allowed to execute transfers.
    address public walletOwner;

    /**
     * @notice Constructor to set the wallet owner as the sender of the transaction.
     * @custom:objective (a) Creation of a basic digital wallet contract with an owner.
     */
    constructor() payable {
        walletOwner = msg.sender; // Assigns the address that deployed the contract as the wallet owner
    }

    /**
     * @notice Transfers a specified amount of Ether to the given address.
     * @dev Only allows the owner of the wallet to perform the transfer.
     * @param _to The address to which the funds are to be sent.
     * @param _amount The amount of Ether to be sent in wei.
     * @custom:objective (b) Implementation of a transfer function, only allowing the wallet's owner to transfer funds.
     * @custom:objective (c) Usage of the tx.origin to check the origin of the transaction and demonstrate the vulnerability.
     */
    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == walletOwner, "Only Owner"); // Checks that the transaction origin is the owner

        (bool sent, ) = _to.call{value: _amount}(""); // Sends the specified amount to the given address
        require(sent, "Failed"); // Checks that the transaction was successful
    }
}
