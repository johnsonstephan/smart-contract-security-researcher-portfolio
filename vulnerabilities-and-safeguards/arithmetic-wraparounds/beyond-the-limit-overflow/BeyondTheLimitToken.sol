/*
@title BeyondTheLimitToken (Custom Token Contract)
@notice This contract creates a custom token with minting functionality. It demonstrates a critical issue that can lead to token overflow.

Objectives: 
(a) Provide a basic token implementation using SafeMath to prevent wraparounds.
(b) Initialize the contract with an initial supply 
(c) Include minting functionality that only the manager can access.
(d) Provide basic token transfer and batch transfer functions.

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

library SafeMath {

  /**
  * @notice Multiplies two numbers, throws on overflow.
  * @param a The first multiplicand.
  * @param b The second multiplicand.
  * @return The product of the two multiplicands.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0; // Return 0 if the first multiplicand is 0
    }
    uint256 c = a * b;
    assert(c / a == b); // Ensure that no overflow occurred
    return c;
  }

  /**
  * @notice Divides two numbers and returns the quotient.
  * @param a The dividend.
  * @param b The divisor.
  * @return The quotient of the division.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @notice Subtracts two numbers and returns the difference.
  * @param a Minuend.
  * @param b Subtrahend.
  * @return The difference between a and b.
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a); // Ensure that no underflow occurred
    return a - b;
  }

  /**
  * @notice Adds two numbers and returns the sum.
  * @param a The first addend.
  * @param b The second addend.
  * @return The sum of a and b.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a); // Ensure that no overflow occurred
    return c;
  }
}

contract BeyondTheLimitToken {

  using SafeMath for uint;

  // Mapping to track the balances of each address
  mapping(address => uint) balances;
  
  // The total supply of tokens
  uint public totalSupply;

  // The address that manages the contract
  address public manager;

  // @custom:objective (b) Create a constructor that sets the initial supply of tokens
  constructor(uint _initialSupply) {
    manager = msg.sender; // The deployer is set as the manager
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  // Modifier to restrict functions to the manager only
  modifier onlyManager {
    require(msg.sender == manager, "Only the manager can call this function");
    _;
  }

  // @custom:objective (c) Include a minting functionality that only the manager can access
  /**
  * @notice Mints a specified amount of tokens to the given address.
  * @param to The recipient's address.
  * @param amount The amount of tokens to mint.
  * @dev Can only be called by the manager.
  */
  function mint(address to, uint amount) external onlyManager {
    balances[to] = balances[to].add(amount); // Add the minted amount to the recipient's balance
    totalSupply = totalSupply.add(amount); // Increase the total supply accordingly
  }

  // @custom:objective (d) Provide basic token transfer function
  /**
  * @notice Transfers a specified amount of tokens to a given address.
  * @param _to The recipient's address.
  * @param _value The amount of tokens to transfer.
  * @return A boolean value indicating whether the operation succeeded.
  */
  function transfer(address _to, uint _value) external returns (bool) {
    require(balances[msg.sender] >= _value, "Not enough tokens");
    balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract the transferred amount from the sender's balance
    balances[_to] = balances[_to].add(_value); // Add the transferred amount to the recipient's balance
    return true;
  }

// @custom:objective (d) Provide batch token transfer function
  /**
  * @notice Transfers a specified amount of tokens to multiple recipients.
  * @param _receivers An array of recipient addresses.
  * @param _value The amount of tokens to transfer to each recipient.
  * @return A boolean value indicating whether the operation succeeded.
  */
  function batchTransfer(address[] memory _receivers, uint _value) external returns (bool) {
    uint totalAmount = _receivers.length * _value; // Calculate the total amount to transfer
    require(_value > 0, "Value can't be 0" );
    require(balances[msg.sender] >= totalAmount, "Not enough tokens");

    balances[msg.sender].sub(totalAmount); // Subtract the total transferred amount from the sender's balance

    // Iterate through the recipients and transfer the specified value to each one
    for(uint i = 0; i < _receivers.length; i++) {
      balances[_receivers[i]] = balances[_receivers[i]].add(_value);
    }
    
    return true;
  }

  /*
  * @notice Retrieves the balance of a given address.
  * @param _owner The address whose balance is to be queried.
  * @return The balance of the specified address.
  */
  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner]; // Return the balance of the specified address
  }
}
