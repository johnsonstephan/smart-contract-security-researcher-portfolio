# Custom ERC20 Token

This project demonstrates the creation, deployment, and testing of a custom ERC20 token based on the OpenZeppelin ERC20.sol contract. The token is deployed to a local hardhat chain for testing purposes.

## Accounts

- 0 - Deployer & Owner
- 1 - User1
- 2 - User2
- 3 - User3

## Tasks

1. Import and inherit the OpenZeppelin ERC20.sol contract
2. Select a NAME and SYMBOL for the custom token
3. Assign a contract owner during deployment
4. Develop an external `mint()` function that can only be invoked by the owner

## Testing

1. Deploy the contract using the deployer account
2. Issue 50K tokens to the deployer
3. Allocate 10K tokens to each of the users
4. Test that each user possesses the intended amount of tokens
5. Transfer 200 tokens from User2 to User3
6. From User3, approve User1 to spend 2K tokens
7. Test that User1 has the correct allowance provided by User3
8. From User1, collect 2K tokens from User3 with `transferFrom()`
9. Test that every user has the correct amount of tokens in their respective accounts

## Files

1. [JohnsonToken.sol](./JohnsonToken.sol) - The custom ERC20 token contract
2. [JohnsonToken-tests.js](./JohnsonToken-tests.js) - The test suite for the custom ERC20 token
