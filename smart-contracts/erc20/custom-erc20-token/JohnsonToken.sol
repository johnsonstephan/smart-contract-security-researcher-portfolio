// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC20 contract from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Johnson Token Contract
 * @notice This contract creates a new ERC20 token named "Johnson Token" with symbol "JSN".
 * @dev Inherits the ERC20 contract from OpenZeppelin and includes an additional mint function accessible only by the owner.
 */
contract JohnsonToken is ERC20 {

    /**
     * @dev State variables:
     *      owner - The address of the owner of this contract, who has special permissions like minting tokens.
     *      _name - The name of the token.
     *      _symbol - The symbol of the token.
     */
    address public owner;
    string private _name;
    string private _symbol;
    
    /**
     * @notice Constructor to set up the Johnson Token.
     * @dev Sets the name and symbol of the token, and assigns the contract deployer as the owner.
     */
    constructor() ERC20("Johnson Token", "JSN") {
        
        // Initialize the name and symbol of the token
        _name = "Johnson Token";
        _symbol = "JSN";

        // Set the contract owner to the address that deployed the contract
        owner = msg.sender;

    }

    /**
     * @dev onlyOwner modifier to restrict function access to the contract owner.
     * @notice This function will revert with "Only the owner can call this function" if the caller is not the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    /**
     * @notice Implements a mint function which allows the owner to create new tokens.
     * @dev Calls the internal _mint function from the ERC20 OpenZeppelin contract, so tokens are correctly minted following the ERC20 standard.
     * @param account_mint_to The address to mint the tokens to.
     * @param mint_amount The amount of tokens to mint.
     */
    function mint(address account_mint_to, uint256 mint_amount) external onlyOwner {
        _mint(account_mint_to, mint_amount);
    }

}