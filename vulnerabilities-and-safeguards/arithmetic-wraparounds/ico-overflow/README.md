# QuantumPortfolios ICO Overflow

QuantumPortfolios is a next-generation investment platform that leverages cutting-edge quantum computing techniques and artificial intelligence to optimize investment decisions and manage portfolios. The platform announced the launch of its initial coin offering (ICO) for the QuantumPortfolios Token, the primary form of payment and access to exclusive features. The following is an exercise to analyze and exploit the related smart contracts.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### Introduction

This project is focused on the QuantumPortfolios ICO and consists of two smart contracts: the ICO contract (`QuantumPortfoliosICO.sol`) and the associated token contract (`QuantumPortfoliosToken.sol`). The exercise is aimed at exploiting the ICO contract.

### Users

1. **Deployer & Owner**: Responsible for deploying and managing the ICO
2. **Investor 1, Investor 2, Investor 3**: Investors who participate in the ICO
3. **Attacker (You)**: The entity conducting the analysis and testing the vulnerability of the contracts

### Development

#### 3.1. <a name='QuantumPortfoliosToken.sol'></a>QuantumPortfoliosToken.sol

1. Develop the QuantumPortfoliosToken smart contract, representing the token used for the platform.
2. Ensure adherence to ERC20 standards.

#### 3.2. <a name='QuantumPortfoliosICO.sol'></a>QuantumPortfoliosICO.sol

1. Develop the QuantumPortfoliosICO.sol smart contract, governing the ICO process.

### Testing

#### 4. <a name='Testing'></a>Testing

Validate functionality to cover the following:

- Deployment of QuantumPortfolios Token and ICO contracts
- Investing and receiving tokens
- The overflow exploitation

### Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### Files

- [`QuantumPortfoliosICO`](./QuantumPortfoliosICO.sol): The main contract governing the ICO
- [`QuantumPortfoliosToken`](./QuantumPortfoliosToken.sol): The ERC20 token contract used in the platform
- [`QuantumPortfolios-tests.js`](./QuantumPortfolios-tests.js): Test file containing tests for the smart contracts
