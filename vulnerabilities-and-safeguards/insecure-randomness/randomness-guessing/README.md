# Random Vulnerabilities Guessing

This project is a practical exercise in smart contract security, showcasing how a poorly designed random number generation mechanism can be exploited. The project includes a smart contract representing a game where players can win 15 ETH by guessing a specific number. The aim of the project is to discover and exploit the vulnerability to drain the game contract of its funds.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

## 1. <a name='Introduction'></a>Introduction

This project contains two smart contracts. This first is `RandomVulnerabilitiesGuessing.sol`, which allows players to deposit ETH and guess a number. If the guessed number is correct, the player wins the entire game pot. The aim is to exploit the contract's weak randomness mechanism to consistently predict the winning number and drain the contract of its funds.

The second contract is `Attack.sol`, which is used to drain the game contract of its funds. The attack contract is deployed by the attacker and is used to predict the winning number and win the game.

## 2. <a name='Users'></a>Users

1. **Contract Owner & Deployer**: This user deploys the contract and is responsible for starting the game with an initial pot of 15 ETH.
2. **Attacker (Player)**: This user participates in the game by guessing numbers and attempting to drain the contract of its funds by exploiting the contract's weak randomness mechanism.

## 3. <a name='Development'></a>Development

### 3.1. <a name='RandomVulnerabilitiesGuessing.sol'></a>RandomVulnerabilitiesGuessing.sol

1. Develop the game contract `RandomVulnerabilitiesGuessing.sol` by allowing users to guess a number and win the balance if their guess is correct.

### 3.2. <a name='Attack.sol'></a>Attack.sol

1. Develop the attack contract `Attack.sol` by allowing the attacker to drain the game contract of its funds by predicting the winning number.

## 4. <a name='Testing'></a>Testing

Validate functionality to cover the following:

- Winning the game and receiving the pot when the guessed number is correct

## 5. <a name='BuiltWith'></a>Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

## 6. <a name='Files'></a>Files

- [`RandomVulnerabilitiesGuessing.sol`](./RandomVulnerabilitiesGuessing.sol): The main contract for the game, allowing users to guess a number and win the pot if their guess is correct.
- [`Attack.sol`](./Attack.sol): The attack contract, allowing the attacker to drain the game contract of its funds.
- [`RandomVulnerabilitiesGuessing-tests.js`](./RandomVulnerabilitiesGuessing-tests.js): Test file containing tests for the game contract.
