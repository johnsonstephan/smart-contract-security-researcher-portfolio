# Token Depository and Receipt Token Project

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Files](#Files)

## 1. <a name='Introduction'></a>Introduction

This project is a collection of two smart contracts that allows users to deposit supported ERC20 tokens (AAVE, UNI, WETH) and receive receipt tokens with the "r" prefix (rAAVE, rUNI, rWETH). Users can later claim back their deposited tokens by providing the receipt tokens to the depository. This project is executed on an Ethereum mainnet fork.

## 2. <a name='Users'></a>Users

1. Contract Owner: The owner of the contract is responsible for minting and burning receipt tokens
2. Depositor: Users who deposit supported ERC20 tokens and receive receipt tokens in return

## 3. <a name='Development'></a>Development

### 3.1. <a name='rToken.sol'></a>rToken.sol

1. Develop the ERC20 receipt tokens contract (rToken.sol) by inheriting from OpenZeppelin's ERC20.sol
2. Implement minting and burning of tokens, only by the contract owner

### 3.2. <a name='TokensDepository.sol'></a>TokensDepository.sol

3. Complete the TokensDepository.sol Smart contract, allowing users to:

   - Deposit supported assets and receive receipt tokens
   - Withdraw deposited assets by providing the receipt tokens

4. Ensure deployment of the receipt tokens contracts upon the contract deployment
5. Ensure the contract is the owner of the receipt tokens contracts
6. Burn the receipt token upon withdrawal

### 3.3. <a name='TestFile'></a>Test File

7. Validate functionality to cover the following:

   - Deployment and minting of ERC20 tokens
   - Depositing supported assets and receiving receipt tokens
   - Withdrawing deposited assets by providing the receipt tokens
   - Burning the receipt token upon withdrawal

## 4. <a name='Files'></a>Files

- [`rToken.sol`](./rToken.sol): The ERC20 receipt token contract
- [`TokensDepository.sol`](./TokensDepository.sol): The main contract for depositing and withdrawing supported ERC20 tokens
- [`Depository-tests.js`](./Depository-tests.js): Test file containing tests for the smart contracts
