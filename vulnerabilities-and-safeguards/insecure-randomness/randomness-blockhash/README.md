# Random Blockhash Testing Suite

This project serves as an exercise in understanding and exploiting vulnerabilities related to blockchain randomness. The goal is to simulate an attack on a game that requires a user to win ten consecutive times. It demonstrates that randomness based on the blockhash can be exploited.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### Introduction

The project comprises two smart contracts namely `RandomBlockhash.sol` and `Attack.sol`. The main contract `RandomBlockhash.sol` represents a game where the user has to win ten times in a row. An attack is simulated on this contract using `Attack.sol` with the goal of draining the entire ETH held by the main contract.

### Users

1. Deployer & Owner: This user deploys the smart contract and owns the deployed contract.
2. Attacker: This user interacts with the deployed smart contract with the aim of exploiting the contract's vulnerability.

### Development

#### 3.1 <a name='RandomBlockhash.sol'></a>RandomBlockhash.sol

1. The main contract of the game, it contains the core logic of the game which requires a user to win ten consecutive times.
2. It holds an initial amount of ETH (25 ETH) as the game pot which the attacker will try to drain.

#### 3.2 <a name='RandomBlockhash-tests.js'></a>RandomBlockhash-tests.js

1. Contains the tests that verify the attacker can win ten times in a row and drain the entire ETH from the `RandomBlockhash.sol` contract.

#### 3.3 <a name='Attack.sol'></a>Attack.sol

1. Simulates an attack on the `RandomBlockhash.sol` contract, to drain all the ETH from the contract.

### Testing

Testing covers the following areas:

1. Winning the game by playing ten times in a row and taking all the ETH from the `RandomBlockhash.sol` smart contract.

### Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### Files

- [`RandomBlockhash`](./RandomBlockhash.sol): The main contract representing the game
- [`Attack`](./Attack.sol): The contract simulating an attack on the main game contract
- [`RandomBlockhash-tests.js`](./RandomBlockhash-tests.js): Contains tests for the main game contract
