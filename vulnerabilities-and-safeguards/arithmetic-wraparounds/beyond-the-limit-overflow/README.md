# Beyond The Limit (Token Overflow)

This testing suite is designed to explore and exploit a known vulnerability related to overflow issues. The game involves finding a way to exploit the smart contract to create tokens beyond the initial supply.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### Introduction

This project is a single smart contract that represents a hypothetical token with an overflow vulnerability. It has an exploitable property which allows one to create tokens beyond the initial supply of 1.70 million.

### Users

1. **Deployer & Owner**: The creator of the smart contract.
2. **Attacker (You)**: The person attempting to exploit the vulnerability and create tokens beyond the initial supply.

### Development

#### 3.1. <a name='BeyondTheLimitToken.sol'></a>BeyondTheLimitToken.sol

This smart contract file represents the core of the exercise with an embedded vulnerability allowing overflow.

### Testing

#### 4. <a name='Testing'></a>Testing

The testing validates the functionality covering the following:

- Exploiting the vulnerability to create tokens beyond the initial supply of 1.70 million

### Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### Files

- [`BeyondTheLimitToken`](./BeyondTheLimitToken.sol): The main token contract containing the overflow vulnerability
- [`TokenOverflow-tests.js`](./TokenOverflow-tests.js): Test file containing tests for the smart contract
