/* 
@title ParodiNFT (ERC-721 Token Contract)
@notice This contract creates an ERC-721 token based on the OpenZeppelin ERC-721 contract. It provides additional minting functionality and tracks the current supply.
@dev Based on OpenZeppelin's ERC721 contract.

Objectives: 
(a) Import and inherit from the OpenZeppelin ERC-721 contract.
(b) Have a constructor that sets the name and symbol for the ERC-721 token.
(c) Include a mint function with a maximum supply of 50,000 tokens and a mint price of 0.5 ETH.
(d) Keep track of the current supply using a public state variable.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @custom:objective (a) Import and inherit from the OpenZeppelin ERC-721 contract
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// @custom:objective (a) Inherit the OpenZeppelin ERC-721 contract 
contract ParodiNFT is ERC721 {

    // @dev Keep track of the current supply using a public state variable.
    // @custom:objective (d) The currentSupply variable tracks the total number of tokens minted by the contract.
    uint256 public currentSupply = 0;

    // @dev Define the max supply for the mint function (immutable so it cannot be changed after deployment).
    // @custom:objective (c) The MAX_SUPPLY variable is the upper limit on the total number of tokens that can be minted.
    uint256 immutable public MAX_SUPPLY = 50000;

    // @dev Define the mint price for the mint function (immutable so it cannot be changed after deployment).
    // @custom:objective (c) The MINT_PRICE variable sets the cost in ether to mint a new token.
    uint256 immutable public MINT_PRICE = 0.5 ether; 
    
    // @custom:objective (b) Create a constructor that sets the name and symbol for the ERC-721 token
    constructor() ERC721('ParodiNFT', 'MAPP') {}

    /* 
    @notice Allows users to mint new tokens.
    @dev Implement a mint function with a maximum supply of 50,000 tokens and a mint price of 0.5 ETH.
    @return The ID of the newly minted token.
    @custom:objective (c) Define and implement the mint function with the specified conditions.
    */
    function mint() external payable returns (uint256) {
        // Enforce the max supply limit.
        require(currentSupply < MAX_SUPPLY, "Max supply has been reached.");
        // Enforce the correct payment amount.
        require(msg.value == MINT_PRICE, "Mint price is 0.5 ETH.");
        currentSupply += 1;
        _mint(msg.sender, currentSupply);
        return currentSupply;
    }
}
