// Import the Hardhat's ethers.js library
const { ethers } = require("hardhat");

// Import the Chai's expect library for assertion
const { expect } = require("chai");

// Declare a test suite for the "Random Vulnerabilities Guessing Testing Suite"
describe("Random Vulnerabilities Guessing Testing Suite", function () {
  // Define the accounts that will be used during testing
  let deployer, attacker;

  // Set the initial game pot value to 15 ETH
  const GAME_POT = ethers.utils.parseEther("15");

  // This is the setup block that is run before the test cases
  before(async function () {
    // Fetch the signers (accounts) from the Ethereum network
    [deployer, attacker] = await ethers.getSigners();

    // Store the initial balance of the attacker account for later comparison
    this.attackerInitialBalance = await ethers.provider.getBalance(
      attacker.address
    );

    // Deploy the Game contract and deposit the initial game pot
    const gameFactory = await ethers.getContractFactory(
      "./RandomVulnerabilitiesGuessing.sol:Random Vulnerabilities Guessing",
      deployer
    );
    this.game = await gameFactory.deploy({ value: GAME_POT });

    // Get the current balance of the deployed game contract
    let inGame = await ethers.provider.getBalance(this.game.address);

    // Validate that the current balance in the game contract equals the initial game pot
    it("[Test I] Should deposit initial game pot into the deployed game contract", async function () {
      expect(inGame).to.equal(GAME_POT);
    });
  });

  // This is the main test case that simulates the attacker exploiting the contract
  it("Exploit", async function () {
    // Deploy the Attacker contract with the game contract's address as a parameter
    const attackerFactory = await ethers.getContractFactory("Attack", attacker);
    this.attacker = await attackerFactory.deploy(this.game.address);

    // Execute the 'playtoWin' function of the Attacker contract which attempts to exploit the game contract
    await this.attacker.playtoWin();
  });

  // This block is run after all the test cases and checks whether the attack was successful
  after(async function () {
    // Validate that the game contract's balance is now 0, meaning funds were stolen
    it("[Test II] Should verify the game contract balance is zero after the attack", async function () {
      expect(await ethers.provider.getBalance(this.game.address)).to.equal(0);
    });

    // Validate that the attacker's balance is now greater than his initial balance plus the game pot
    // This implies that the attacker was successful in exploiting the contract
    it("[Test III] Should verify the attacker balance has increased more than the initial game pot", async function () {
      expect(await ethers.provider.getBalance(attacker.address)).to.be.gt(
        this.attackerInitialBalance
          .add(GAME_POT)
          .sub(ethers.utils.parseEther("0.2"))
      );
    });
  });
});
