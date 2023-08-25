# Basic Token Minting Underflow

This project demonstrates an underflow vulnerability related to token minting operations. The focus is on an Ethereum contract that has a balance vulnerability, allowing a user to manipulate their token balance. This project also includes a fixed contract to demonstrate how one may prevent this underflow attack.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

## 1. <a name='Introduction'></a>Introduction

This project revolves around two smart contracts - `BasicToken.sol` and `BasicTokenFixed.sol`. The former has an underflow vulnerability that can be exploited to mint more tokens than intended, while the latter is a revised version of the same contract but with the underflow vulnerability fixed.

## 2. <a name='Users'></a>Users

1. Contract Owner: The owner deploys the contract and mints the initial tokens.
2. Attacker: The user who tries to exploit the contract's vulnerability to mint more tokens for themselves.

## 3. <a name='Development'></a>Development

### 3.1. <a name='BasicToken.sol'></a>BasicToken.sol

1. This contract is an instance of a token that has a vulnerability. The vulnerability allows an attacker to exploit the underflow condition and secure more tokens than allowed.

### 3.2. <a name='BasicTokenFixed.sol'></a>BasicTokenFixed.sol

2. This contract is an improved version of the `BasicToken.sol` contract where the underflow vulnerability is fixed.

## 4. <a name=‘Testing’></a>Testing

The following tests will be conducted:

1. Exploiting the underflow vulnerability to mint more tokens than intended.
2. Testing the revised contract to ensure that the vulnerability is indeed fixed and the contract behaves as expected.

## 5. <a name='BuiltWith'></a>Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

## 6. <a name='Files'></a>Files

- [`BasicToken.sol`](./BasicToken.sol): The initial token contract with a minting vulnerability.
- [`BasicTokenFixed.sol`](./BasicTokenFixed.sol): The improved version of the token contract with the vulnerability fixed.
- [`BasicToken-tests.js`](./BasicToken-tests.js): Test file containing tests for the smart contracts.
