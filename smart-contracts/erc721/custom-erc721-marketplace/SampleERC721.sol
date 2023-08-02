/** 
@title SampleERC721 (Dynamic Supply ERC-721 Token Contract)
@notice This contract inherits from the OpenZeppelin's ERC721 and Ownable contracts to create an ERC-721 token with dynamic supply.
@dev This contract provides functionality for minting tokens with an adjustable maximum supply.

Objectives: 
(a) Import and inherit from the OpenZeppelin's ERC721 and Ownable contracts.
(b) Define a constructor that sets the name, symbol, and maximum supply for the ERC-721 token.
(c) Implement a minting function that checks for the maximum supply before minting a new token.
(d) Provide safe minting functionality to ensure tokens are sent to an ERC721 compatible address.
(e) Implement a bulk minting function that only the contract owner can call.
(f) Keep track of the current supply using a public state variable.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @custom:objective (a) Import and inherit from the OpenZeppelin's ERC721 and Ownable contracts.
 */
contract SampleERC721 is ERC721, Ownable {

    // Maximum supply of the ERC-721 tokens that can be minted.
    uint256 maxSupply;
    // Current supply of the ERC-721 tokens minted.
    uint256 public currentSupply = 0;

    /**
     * @dev Constructor function to initialize the ERC-721 contract.
     * @param _name Name of the ERC-721 token.
     * @param _symbol Symbol of the ERC-721 token.
     * @param _maxSupply Maximum supply of the ERC-721 tokens that can be minted.
     * @custom:objective (b) Define a constructor that sets the name, symbol, and maximum supply for the ERC-721 token.
     */
    constructor(string memory _name, string memory _symbol, uint256 _maxSupply) ERC721(_name, _symbol) {
        maxSupply = _maxSupply;
    }

    /**
     * @dev Function to mint a new ERC-721 token.
     * @notice Anyone can call this function to mint a new token, as long as the maximum supply is not reached.
     * @return tokenId ID of the new token minted.
     * @custom:objective (c) Implement a minting function that checks for the maximum supply before minting a new token.
     */
    function mint() public returns (uint256) {
        uint256 tokenId = _newTokenId();
        _mint(msg.sender, tokenId);
        return tokenId;
    }

    /**
     * @dev Function to safely mint a new ERC-721 token.
     * @notice This function checks if the recipient address can handle ERC721 tokens using the ERC721Receiver interface.
     * @return tokenId ID of the new token minted.
     * @custom:objective (d) Provide safe minting functionality to ensure tokens are sent to an ERC721 compatible address.
     */
    function safeMint() public returns (uint256) {
        uint256 tokenId = _newTokenId();
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    /**
     * @dev Function to mint multiple ERC-721 tokens at once.
     * @notice Only the contract owner can call this function.
     * @param _amount Amount of tokens to mint.
     * @custom:objective (e) Implement a bulk minting function that only the contract owner can call.
     */
    function mintBulk(uint256 _amount) public onlyOwner {
        for(uint256 i = 0; i < _amount; i++) {
            mint();
        }
    }

    /**
     * @dev Internal function to create a new token ID.
     * @notice This function increases the current supply of tokens and checks if the maximum supply is not reached.
     * @return New token ID.
     * @custom:objective (f) Keep track of the current supply using a public state variable.
     */
    function _newTokenId() internal returns (uint256) {
        require(currentSupply < maxSupply, "max supply reached");
        currentSupply += 1;
        return currentSupply;
    }
}
