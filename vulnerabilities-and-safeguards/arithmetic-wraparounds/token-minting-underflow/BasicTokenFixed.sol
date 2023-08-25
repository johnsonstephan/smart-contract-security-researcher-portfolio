/* 
@title BasicTokenFixed (Fixed Simple ERC-20 Token Contract)
@notice This contract provides a basic implementation of an ERC-20 token, including minting and transferring functionalities.

Objective(s): 
(a) Offer a solution to the underflow vulnerability, by updating the solidity version to ^0.8.0

This works because the Solidity compiler version ^0.8.0 has a new feature that prevents integer overflows and underflows.
*/

// SPDX-License-Identifier: MIT

// Update the solidity version to 0.8.0 to fix the underflow bug
pragma solidity ^0.8.0;

contract BasicTokenFixed {

  /// @notice Address of the minter, initially set to the contract deployer.
  address public minter;

  /// @notice Mapping of addresses to their respective token balances.
  mapping(address => uint) public getBalance;

  /// @notice Total supply of tokens in circulation.
  uint public totalSupply;

  /*
   * @dev Constructor that initializes the minter with the address of the contract deployer.
   */
  constructor() public {
    minter = msg.sender; // Set the contract deployer as the minter.
  }

  /*
   * @notice Mints a specified amount of tokens to the given address.
   * @dev Only the minter can call this function.
   * @param _to Address to receive the minted tokens.
   * @param _amount Amount of tokens to be minted.
   */
  function mint(address _to, uint _amount) external {
    require(msg.sender == minter, "Not Minter"); // Ensure the caller is the minter.
    getBalance[_to] += _amount; // Increase the balance of the target address.
  }

  /*
   * @notice Transfers tokens from the sender's address to another address.
   * @dev The function ensures that the sender has enough balance before the transfer.
   * @param _to Address to receive the tokens.
   * @param _value Amount of tokens to be transferred.
   * @return Returns 'true' if the transfer was successful.
   */
  function transfer(address _to, uint _value) public returns (bool) {
    require(getBalance[msg.sender] - _value >= 0); // Ensure the sender has enough tokens.
    getBalance[msg.sender] -= _value; // Reduce the sender's balance.
    getBalance[_to] += _value; // Increase the recipient's balance.
    return true; // Indicate that the transfer was successful.
  }
}

