// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC20 contract from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Create the JohnsonToken contract, which inherits from the OZ ERC20 contract
contract JohnsonToken is ERC20 {

    // Declare state variables for contract owner, token name, and token symbol
    address public owner;
    string private _name;
    string private _symbol;
    
    // Setup the constructor function with the name (Johnson Token) and symbol (JSN)
    constructor() ERC20("Johnson Token", "JSN") {
        
        // Initialize the name and symbol of the token
        _name = "Johnson Token";
        _symbol = "JSN";

        // Set the contract owner to the address that deployed the contract
        owner = msg.sender;

    }

    // Define an onlyOwner modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Implement an external mint function, accessible only by the owner
    function mint(address account_mint_to, uint256 mint_amount) external onlyOwner {
        _mint(account_mint_to, mint_amount);
    }

}