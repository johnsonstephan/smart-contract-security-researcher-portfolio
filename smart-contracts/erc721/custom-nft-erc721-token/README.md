# ERC721 NFT Creation and Management

This project is a demonstration of creating a Non-Fungible Token (NFT) using OpenZeppelin's `ERC721.sol` contract on a local Hardhat blockchain. The NFT contract provides functionality such as minting, transferring, and approving tokens. This project is a demonstration of how ERC721 tokens can be implemented and managed.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

## 1. <a name='Introduction'></a>Introduction

This project consists of one smart contract that allows users to mint, transfer, and approve an ERC721 token. A maximum of 50,000 tokens can be minted, each priced at 0.5 ETH. It was deployed on a local Hardhat blockchain.

## 2. <a name='Users'></a>Users

1. Deployer: This is the account that deploys the smart contract and is initially able to mint tokens.
2. User1 and User2: These are the users who can receive, transfer and get approval to spend the tokens.

## 3. <a name='Development'></a>Development

### 3.1 <a name='ParodiNFT.sol'></a>ParodiNFT.sol

This smart contract serves two primary functions:

1. Development of an ERC721 token contract by inheriting from OpenZeppelin's `ERC721.sol`.
2. The implementation of a mint function to create new tokens with the following properties:
   1. Maximum supply limited to 50,000 tokens.
   2. Minting price set at 0.5 ETH.
3. Maintaining the current supply count with a public state variable.

## 4. <a name='Testing'></a>Testing

Tests to validate the functionality cover the following:

- Deployment of the ERC721 contract by the deployer account
- Minting of tokens by the deployer and User1
- Verification of token ownership across all accounts
- Transfer of a token from User1 to User2
- Approval granted to User1 by the Deployer to spend a token
- Transfer of approved token by User1 to himself
- Final verification of token ownership across all accounts after transfers and approvals

## 5. <a name='BuiltWith'></a>Built With

- OpenZeppelin - Framework used for developing secure smart contracts
- Hardhat - Ethereum development environment
- Solidity - Contract-oriented, high-level language used for implementing smart contracts
- Web3.js - Collection of libraries that allow interaction with a local Ethereum node

## 6. <a name='Files'></a>Files

- [`ParodiNFT.sol`](./ParodiNFT.sol): This is the main contract file that includes the creation, minting, and management of the ERC721 token.
- [`ParodiNFT-tests.js`](./ParodiNFT-tests.js): Test file containing tests for the ParodiNFT smart contract.
