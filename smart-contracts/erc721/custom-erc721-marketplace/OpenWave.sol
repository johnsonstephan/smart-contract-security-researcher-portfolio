/*
@title OpenWave Marketplace Contract
@notice This smart contract provides a marketplace for users to buy, sell, and discover digital items that are compliant with ERC721.
@dev The contract holds a list of digital items that are for sale and facilitates transactions for the purchase of these items.

Objectives:
(a) Create an Item struct which represents an ERC721 item that is on sale.
(b) Implement itemsCounter state variable, to keep track of the number of items.
(c) Create listedItems mapping, to keep track of all the items that are on sale.
(d) Develop listItem function, to list an item for sale.
(e) Develop purchase function, to buy an item.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract OpenWave {
    //@custom:objective (a) Creating Item struct to represent an ERC721 item on sale
    struct Item { 
        uint256 itemId; // Unique identifier for an item in the marketplace
        address collection; // Address of the ERC721 collection to which the item belongs
        uint256 tokenId; // Unique identifier of the ERC721 token within its collection
        uint256 price; // Price of the item in ETH
        address payable seller; // Address of the seller of the item
        bool isSold; // Flag to check if the item has been sold or not
    }
    
    //@custom:objective (b) Implementing itemsCounter state variable to track the number of items
    uint256 public itemsCounter;

    //@custom:objective (c) Creating listedItems mapping to keep track of all items that are on sale
    mapping(uint256 => Item) public listedItems;

    constructor() {}

    /**
     * @custom:objective (d) listItem function for users to list their items for sale
     * @param _collection Address of the ERC721 collection to which the item belongs.
     * @param _tokenId Unique identifier of the ERC721 token within its collection.
     * @param _price Price of the item in ETH.
     * @notice The ERC721 token is transferred from the caller to the contract.
     */
    function listItem(address _collection, uint256 _tokenId, uint256 _price) external {
        require(_price != 0 && _price <= maxPrice, "Incorrect price"); // Check that the price is valid
        itemsCounter +=1; // Increment the items counter
        IERC721(_collection).transferFrom(msg.sender, address(this), _tokenId); // Transfer the ERC721 token to the contract
        listedItems[itemsCounter] = Item(itemsCounter, _collection, _tokenId, _price, payable (msg.sender), false); // Add the item to the marketplace
    }

    /**
     * @custom:objective (e) purchase function for users to buy listed items
     * @param _itemId Unique identifier for an item in the marketplace.
     * @notice The buyer sends ETH to the contract, which is then forwarded to the seller. The ERC721 token is transferred to the buyer.
     */
    function purchase(uint _itemId) external payable {
        require(_itemId != 0 && _itemId <= itemsCounter, "Incorrect _itemID"); // Check that the item exists
        Item storage item = listedItems[_itemId]; // Load the item from the mapping
        require(item.isSold == false, "This cannot be purchased, as the item is already sold"); // Check that the item is not already sold
        require(msg.value == item.price, "Incorrect price sent for the purchase"); // Check that the correct price has been paid
        item.isSold = true; // Mark the item as sold
        IERC721(item.collection).transferFrom(address(this), msg.sender, item.tokenId); // Transfer the ERC721 token to the buyer
        (bool sent, bytes memory data) = item.seller.call{value: msg.value}(""); // Transfer the ETH to the seller
        require(sent, "Failed to send Ether to seller"); // Check that the ETH transfer was successful
    }
}
