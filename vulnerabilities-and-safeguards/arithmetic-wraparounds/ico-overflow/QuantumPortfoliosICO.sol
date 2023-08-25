/* 
@title QuantumPortfoliosICO (ICO Contract for Quantum Portfolios Token)
@notice This contract handles the initial sale of QuantumPortfoliosToken. It provides functionalities for buying tokens, refunding, and administration.
@dev Based on a typical ICO contract structure. 

Objectives: 
(a) Import and use the QuantumPortfoliosToken contract.
(b) Implement a constructor that initializes the ICO with a starting time and an administrator.
(c) Include a function for users to buy tokens.
(d) Include a function for users to refund tokens before the sale ends.
(e) Include functions for the administrator to withdraw the balance, mint tokens, and change the admin.
(f) Handle the constant sale period of 2 days.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./QuantumPortfoliosToken.sol";

contract QuantumPortfoliosICO {

    uint256 constant public SALE_PERIOD = 2 days; // @notice Represents the sale period in days

    QuantumPortfoliosToken public token; // @notice Reference to the token contract
    uint256 public startTime; // @notice Time when the ICO starts
    address public admin; // @notice Address of the administrator

    // @notice Modifier to ensure that only the administrator can execute certain functions
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin");
        _;
    }

    // @custom:objective (b) Implement a constructor that initializes the ICO with a starting time and an administrator
    constructor() {
        token = new QuantumPortfoliosToken(); // @notice Creates a new token contract
        admin = msg.sender; // @notice Sets the administrator as the deployer
        startTime = block.timestamp; // @notice Sets the start time of the ICO
    }

    // @custom:objective (c) Include a function for users to buy tokens
    function buy(uint256 numTokens) public payable {
        // @notice Checks if the ICO sale period is over
        require(block.timestamp <= startTime + SALE_PERIOD, "The ICO sale period is over");
        
        // @notice Checks if the sent Ether corresponds to the number of tokens requested (1 Token = 0.1 ETH)
        require(msg.value == numTokens * 10 / 100, "Incorrect ETH amount");

        token.mint(msg.sender, numTokens); // @notice Mints the tokens and sends them to the buyer
    }

    // @custom:objective (d) Include a function for users to refund tokens before the sale ends
    function refund(uint256 numTokens) public {
        // @notice Checks if the ICO sale period is still ongoing
        require(block.timestamp < startTime + SALE_PERIOD, "The ICO sale period is over");

        token.burn(msg.sender, numTokens); // @notice Burns the tokens, effectively refunding them

        // @notice Sends the equivalent Ether back to the user (1 Token = 0.1 ETH)
        payable(msg.sender).call{value: numTokens * 10 / 100}("");
    }

    // @notice Allows the admin to withdraw the balance after the sale period
    function adminWithdraw() external onlyAdmin {
        // @notice Ensures that the sale period is over
        require(block.timestamp > startTime + SALE_PERIOD, "The ICO sale period is not over yet");
        payable(msg.sender).call{value: address(this).balance}(""); // @notice Transfers the contract's balance to the administrator
    }

    // @notice Allows the admin to mint additional tokens
    function adminMint(address _to, uint256 _amount) external onlyAdmin {
        token.mint(_to, _amount); // @notice Mints tokens to the specified address
    }

    // @notice Allows the admin to change the administrator address
    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0)); // @notice Ensures that the new admin address is valid
        admin = _newAdmin; // @notice Sets the new admin address
    }
}
