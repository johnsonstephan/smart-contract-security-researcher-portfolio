# Timed Vault Overflow

This project demonstrates solving an overflow issue present in smart contracts that involve time locking. The fixed contract illustrates one way to correctly manage arithmetic issues in smart contracts, preventing the overflow attack.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

## 1. Introduction

This project contains two smart contracts: `TimedVaultOverflow.sol` and `TimedVaultOverflowFixed.sol`. The first one demonstrates a time lock vulnerability, while the second one fixes this vulnerability. The contract locks deposited ETH for 60 days.

## 2. Users

1. Contract Owner (Deployer): The owner deploys and manages the smart contract.
2. Victim: The user who deposits ETH into the smart contract.
3. Attacker: The user who attempts to bypass the time lock and withdraw the Victim's ETH.

## 3. Development

### 3.1. TimedVaultOverflow.sol

This contract showcases a time-locking smart contract vulnerable to an underflow attack.

1. Deploy the contract with a locked period of 60 days.
2. Allow the Victim to deposit ETH.

### 3.2. TimedVaultOverflowFixed.sol

This contract contains the solution to the underflow vulnerability present in `TimedVaultOverflow.sol`.

1. Correct the time lock implementation to ensure no ETH can be withdrawn until the lock period has passed.

## 4. Testing

Functionality tested includes:

- Attacker's ability to bypass the time lock and withdraw the Victim's ETH.
- Verify the fixed contract `TimedVaultOverflowFixed.sol` ensures security by patching the vulnerability.

## 5. Built With

- OpenZeppelin: Framework used for developing secure smart contracts.
- Hardhat: Ethereum development environment.
- Solidity: Contract-oriented, high-level language used for implementing smart contracts.
- Web3.js: Collection of libraries that allow interaction with an Ethereum node.

## 6. Files

- [`TimedVaultOverflow.sol`](./TimedVaultOverflow.sol): The vulnerable time-locking smart contract.
- [`TimedVaultOverflowFixed.sol`](./TimedVaultOverflowFixed.sol): The fixed version of the time-locking smart contract.
- [`TimedVaultOverflow-tests.js`](./TimedVaultOverflow-tests.js): Test file containing tests for the smart contracts.
