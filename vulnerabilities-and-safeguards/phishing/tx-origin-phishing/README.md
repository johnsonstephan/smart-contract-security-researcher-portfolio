# Tx Origin Phishing: The NFT Collector's Wallet

This project revolves around creating a secure environment for a renowned NFT collector, who has recently transferred 1500 ETH from art sale profits into a single wallet. The collector frequently sponsors virtual art exhibitions and purchases unique NFTs from emerging artists. The exercise aims to explore and uncover a vulnerability through a simulated phishing exercise, and then secure the wallet from such attacks.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### <a name="Introduction"></a>Introduction

This project is a set of three smart contracts.

1. `BasicDigitalWallet.sol`: A contract that emulates the NFT Collector's wallet.
2. `BasicDigitalWalletSecured.sol`: This contract builds upon the initial digital wallet, implementing security measures to fix the phishing vulnerability.
3. `ArtGallery.sol`: A contract representing the art gallery with whom the NFT Collector interacts.

### <a name="Users"></a>Users

1. NFT Collector: Responsible for owning and transferring funds into the digital wallet
2. Attacker (You): Participant in the phishing exercise, attempting to exploit the Collector's wallet

### <a name="Development"></a>Development

#### 3.1. <a name='BasicDigitalWallet.sol'></a>BasicDigitalWallet.sol

1. Develop the `BasicDigitalWallet.sol` contract, allowing the NFT Collector to deposit and interact with art galleries
2. Implement donation functionality, interacting with the `ArtGallery.sol`

#### 3.2. <a name='BasicDigitalWalletSecured.sol'></a>SimpleSmartWalletSecured.sol

1. Improve and secure the original `BasicDigitalWallet.sol` by fixing the vulnerability

#### 3.3. <a name='ArtGallery.sol'></a>ArtGallery.sol

1. Implement the `ArtGallery.sol` contract to receive donations and interact with NFT Collector

### <a name='Testing'></a>Testing

Validate functionality to cover the following:

- Identification and exploitation of phishing vulnerability

### <a name="BuiltWith"></a>Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### <a name="Files"></a>Files

- [`BasicDigitalWallet`](./BasicDigitalWallet.sol): The main contract for managing the NFT collector's digital vault
- [`BasicDigitalWalletSecured`](./BasicDigitalWalletSecured.sol): Improved and secured version of the digital wallet
- [`BasicDigitalWallet-tests.js`](./BasicDigitalWallet-tests.js): Test file containing tests for the smart contracts
