/* 
@title BasicDigitalWalletSecured (Simple Smart Wallet with Security Measures)
@notice This contract functions as a basic digital wallet, only allowing the owner to initiate transfers.
@dev Designed with a security fix to prevent Tx Origin Phishing by requiring that only the wallet owner can initiate transfers.

Objectives:
(a) Declare and initialize the owner's address.
(b) Have a constructor that sets the wallet owner to the creator of the contract.
(c) Include a transfer function that allows only the owner to send funds.

Solution: 
The wallet initially used 'tx.origin' for authentication, which was vulnerable to phishing attacks. 
The solution was to replace 'tx.origin' with 'msg.sender', ensuring that only the owner could initiate a transfer. 
This change protects the contract against phishing attacks by malicious contracts that try to impersonate the owner.

Explanation:
The vulnerability existed because 'tx.origin' returns the original sender of the transaction, which could be exploited in phishing attacks. 
By using 'msg.sender', which returns the direct sender of the call, the contract ensures that only the owner can initiate transfers, thereby eliminating this phishing risk.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * @title BasicDigitalWalletSecured
 */
contract BasicDigitalWalletSecured {
    /// @notice Wallet owner's address
    /// @dev Stores the address of the person who deployed the contract.
    address public walletOwner;

    /**
     * @notice Constructor to initialize the wallet with the deploying address as the owner.
     * @custom:objective (b) Have a constructor that sets the wallet owner to the creator of the contract.
     */
    constructor() payable {
        walletOwner = msg.sender; // Sets the deploying address as the wallet owner.
    }

    /**
     * @notice Transfer the specified amount of Ether to a given address.
     * @dev Allows only the wallet owner to transfer funds.
     * @param _to The address to transfer the funds to.
     * @param _amount The amount of Ether to transfer (in wei).
     * @custom:objective (c) Include a transfer function that allows only the owner to send funds.
     */
    function transfer(address payable _to, uint _amount) public {
        // Updated security measure, using msg.sender instead of tx.origin. 
        require(msg.sender == walletOwner, "Only Owner");

        // Transfer the specified amount to the given address.
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed"); // Ensure the transfer was successful.
    }
}
