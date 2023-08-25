# NFT Airdrop Reentrancy

The Nonchalant Primate Harbor Collective is an NFT project centered around the minting of unique Primates. Limited to 111 unique Primates, the community members are entitled to mint 1 Primate per wallet.

This project contains smart contracts that allow the minting of the Primates and includes an attack simulation to demonstrate a re-entrancy attack via `_safeMint` through `_checkOnERC721Received`. The exercise explores a reentrancy attack and presents ways to secure against them.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### Introduction

This project includes `PrimatesAirdrop.sol` which supports minting the Primates, `PrimatesAirdropSecured.sol` which includes protections against the reentrancy, and an attack contract `AirdropHack.sol` that is used to demonstrate the reentrancy attack.

### Users

1. **Deployer & Owner**: The individual responsible for deploying the contract and owning the contract's functions
2. **User 1 to User 4**: Users that are entitled to mint 1 Primate NFT
3. **Attacker (You)**: The person simulating an attack to mint all 111 NFTs

### Development

#### 3.1. <a name='PrimatesAirdrop.sol'></a>PrimatesAirdrop.sol

1. Implement the ERC721 contract for minting Nonchalant Primate Harbor Collective NFTs
2. Restrict minting to 1 Primate per wallet

#### 3.2. <a name='PrimatesAirdropSecured.sol'></a>PrimatesAirdropSecured.sol

1. Change from `_safeMint` to `_mint` for a more secure minting process
2. Update the claim first (effect) before the minting (interaction)
3. Add ReentrancyGuard to the mint function

#### 3.3. <a name='AirdropHack.sol'></a>AirdropHack.sol

1. Develop to demonstrate a reentrancy attack via `_safeMint` through `_checkOnERC721Received`

### Testing

#### 4. <a name='Testing'></a>Testing

Validate functionality to cover the following:

- Bypassing the 1 Primate per Wallet restriction via reentrancy attack
- Ensure the secured contract is not vulnerable to the reentrancy attack

### Built With

- OpenZeppelin: Framework used for developing secure smart contracts
- Hardhat: Ethereum development environment
- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Web3.js: Collection of libraries that allow interaction with an Ethereum node

### Files

- [`PrimatesAirdrop`](./PrimatesAirdrop.sol): The main contract for minting Nonchalant Primate Harbor Collective NFTs
- [`PrimatesAirdropSecured`](./PrimatesAirdropSecured.sol): The secured version of the contract with reentrancy protections
- [`AirdropHack`](./AirdropHack.sol): Contract simulating the reentrancy attack
- [`PrimatesAirdrop-tests.js`](./PrimatesAirdrop-tests.js): Test file containing tests for the contracts
