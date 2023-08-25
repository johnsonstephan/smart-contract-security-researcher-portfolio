# CryptoBank Reentrancy

This project demonstrates the reentrancy vulnerability in the `CryptoBank.sol` contract. It includes the vulnerable contract, a secured version with fixes (`CryptoBankSecured.sol`), and a contract to showcase the vulnerability (`CryptoBankHack.sol`).

The `CryptoBank.sol` contract is vulnerable to reentrancy attacks because it allows the attacker to withdraw Ether from the contract before the balance is updated. The `CryptoBankSecured.sol` contract fixes the reentrancy vulnerability by updating the balance before sending Ether to the user. The `CryptoBankHack.sol` contract demonstrates the reentrancy attack on the `CryptoBank.sol` contract.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### 1. <a name="Introduction"></a>Introduction

This project is a collection of three smart contracts that demonstrate the reentrancy vulnerability. It includes an initial vulnerable contract (`CryptoBank.sol`), a fixed version (`CryptoBankSecured.sol`), and an attack contract (`CryptoBankHack.sol`).

### 2. <a name="Users"></a>Users

1. **Depositor**: Users who can deposit and withdraw Ether in the `CryptoBank.sol` and `CryptoBankSecured.sol` contracts.
2. **Attacker**: User who can exploit the vulnerability in the `CryptoBank.sol` contract using `CryptoBankHack.sol`.

### 3. <a name="Development"></a>Development

#### 3.1. <a name='CryptoBank.sol'></a>CryptoBank.sol

1. Handle deposits of Ether into the contract.
2. Allow users to withdraw their deposited Ether.
3. Contains reentrancy vulnerability.

#### 3.2. <a name='CryptoBankSecured.sol'></a>CryptoBankSecured.sol

1. Handle deposits of Ether into the contract.
2. Allow users to withdraw their deposited Ether.
3. Fixes the reentrancy vulnerability found in `CryptoBank.sol` in three ways: (1) update the withdraw function to update the balance before sending Ether to the user, (2) use a mutex to prevent reentrancy, and (3) use OZ's ReentrancyGuard.

#### 3.3. <a name='CryptoBankHack.sol'></a>CryptoBankHack.sol

1. Demonstrates the reentrancy attack on the `CryptoBank.sol` contract.

### 4. <a name='Testing'></a>Testing

Validate functionality to cover the following:

- Exploiting the reentrancy vulnerability in `CryptoBank.sol`
- Ensuring the integrity of the balance in `CryptoBankSecured.sol`

### 5. <a name='BuiltWith'></a>Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### 6. <a name='Files'></a>Files

- [`CryptoBank`](./CryptoBank.sol): The main contract containing the reentrancy vulnerability.
- [`CryptoBankSecured`](./CryptoBankSecured.sol): The secured version of the main contract with reentrancy vulnerability fixes.
- [`CryptoBankHack`](./CryptoBankHack.sol): Contract demonstrating the reentrancy attack.
- [`CryptoBank-tests.js`](./CryptoBank-tests.js): Test file containing tests for the smart contracts.
