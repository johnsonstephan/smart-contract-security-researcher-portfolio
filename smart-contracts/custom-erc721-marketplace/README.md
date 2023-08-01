# OpenWave ERC721 Marketplace

OpenWave aims to be the world's largest digital marketplace for crypto collectibles and non-fungible tokens (NFTs). This project provides a marketplace smart contract that enables users to buy, sell, and discover exclusive digital items.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

## 1. <a name='Introduction'></a>Introduction

The OpenWave project consists of two smart contracts - `OpenWave.sol` and `SampleERC721.sol`. The `OpenWave.sol` contract enables the marketplace functionalities such as listing NFT items for sale and buying these items. The `SampleERC721.sol` contract, on the other hand, is a test contract that is used to simulate the ERC721 NFTs during the development and testing phases.

## 2. <a name='Users'></a>Users

1. Deployer: Responsible for deploying the marketplace smart contract.
2. User1, User2, User3: These represent generic users in the system who can list their NFTs and purchase listed NFTs.

## 3. Development

### 3.1 OpenWave.sol

The core functionality of the `OpenWave.sol` contract can be broken down as follows:

- A constant `maxPrice` is set to 75 ether, indicating the maximum price for an NFT listing.
- The `Item` struct represents an NFT item listed for sale on the marketplace. It includes properties such as itemId, collection contract address, tokenId, price, seller's address, and the sale status.
- The `itemsCounter` state variable tracks the total number of items listed on the marketplace.
- The `listedItems` mapping links an itemId to its corresponding `Item` struct.
- The `listItem` function enables users to list their NFTs for sale. This function takes the collection contract address, the tokenId, and the listed price as arguments. It then verifies these parameters, increments the `itemsCounter`, transfers the token from the user to the contract, and adds the item to the `listedItems` mapping.
- The `purchase` function allows users to buy listed items. This function verifies the item's existence and its sale status, checks if sufficient ETH has been provided, updates the item status to "sold", transfers the NFT to the buyer, and transfers the ETH to the seller.

### 3.2 SampleERC721.sol

The `SampleERC721.sol` contract is used as a mock ERC721 contract for testing the `OpenWave.sol` contract. It inherits from the ERC721 contract provided by OpenZeppelin.

## 4. <a name='Testing'></a>Testing

The `OpenWave-tests.js` script validates the following:

1. Successful deployment of the marketplace contract.
2. Proper listing of NFTs on the marketplace.
3. Correct increment of the `itemsCounter` and ownership transfer of NFTs to the marketplace contract.
4. Successful purchase of listed items, including correct update of item's sale status, correct ownership transfer of NFTs, and correct transfer of ETH.
5. Correct handling of invalid scenarios such as trying to purchase non-existing items, making purchases without providing ETH, and attempting to purchase already sold items.

## 5. <a name='BuiltWith'></a>Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with a local Ethereum node

## 6. <a name='Files'></a>Files

- [`OpenWave.sol`](./OpenWave.sol): The main marketplace contract allowing users to list and purchase NFTs.
- [`OpenWave-tests.js`](./OpenWave-tests.js): Test suite for the OpenWave contract.
- [`SampleERC721.sol`](./SampleERC721.sol): Mock ERC721 contract for testing purposes.
