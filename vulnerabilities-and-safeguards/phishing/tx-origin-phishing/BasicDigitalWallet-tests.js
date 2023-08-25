// Importing the required Ethereum libraries for testing
const { ethers } = require("hardhat");
const { expect } = require("chai");

// Tx Origin Phishing Testing Suite
// This test suite is designed to simulate and examine the behavior of a basic digital wallet contract and an attacker's contract that seeks to exploit it
describe("Tx Origin Phishing Testing Suite", function () {
  let nftCollector, attacker; // Define variables for NFT collector (victim) and attacker

  // Define constants for the amount of ETH involved in the exercise
  const ART_PROFITS_DEPOSIT = ethers.utils.parseEther("1500"); // 1500 ETH, represents the profits from art to be deposited
  const GALLERY_DONATION = ethers.utils.parseEther("0.2"); // 0.2 ETH, the amount designated for donation to a gallery

  // Before running any tests, this block sets up the initial environment required for the exercise
  before(async function () {
    // Getting the signers; nftCollector represents the victim, attacker represents the malicious entity
    [nftCollector, attacker] = await ethers.getSigners();

    // Initialize the attacker's contract reference as null
    this.attackerContract = null;

    // Store the initial balance of the attacker to later calculate the amount stolen
    this.attackerInitialEthBalance = await ethers.provider.getBalance(
      attacker.address
    );

    // Get the contract factory for the BasicDigitalWallet
    const basicDigitalWalletFactory = await ethers.getContractFactory(
      "./BasicDigitalWallet.sol:BasicDigitalWallet",
      nftCollector
    );

    // Deploy the wallet with an initial deposit representing the profits from art
    this.wallet = await basicDigitalWalletFactory.deploy({
      value: ART_PROFITS_DEPOSIT,
    });

    // Fetch the balance of the smart wallet and ensure it matches the initial deposit
    let smartWalletBalance = await ethers.provider.getBalance(
      this.wallet.address
    );
    // [Test I] Should deploy BasicDigitalWallet and load art profits
    it("[Test I] Should deploy BasicDigitalWallet and load art profits", async function () {
      expect(smartWalletBalance).to.equal(ART_PROFITS_DEPOSIT);
    });
  });
  //

  // This section outlines the steps the attacker takes to exploit the digital wallet
  it("Exploit", async function () {
    // Create and deploy the attacker's contract
    const ArtGalleryFactory = await ethers.getContractFactory(
      "./ArtGallery.sol:ArtGallery",
      attacker
    );

    // Deploying the ArtGallery contract with the address of the victim's wallet
    this.attackerContract = await ArtGalleryFactory.deploy(this.wallet.address);
  });
  // This block defines the actions that take place after the exploit has been executed, as well as the conditions that signify success
  after(async function () {
    // Simulate the NFT collector being tricked into sending a donation to the "gallery" (actually the attacker's contract)
    await nftCollector.sendTransaction({
      to: this.attackerContract.address,
      value: GALLERY_DONATION,
    });

    // [Test II] Should empty the wallet, indicating that the exploit was successful
    it("[Test II] Should empty the wallet", async function () {
      let walletBalance = await ethers.provider.getBalance(this.wallet.address);
      expect(walletBalance).to.equal(0);
    });

    // [Test III] Should prove that the attacker now owns the stolen ETH (minus 0.2 ETH for gas and other considerations)
    it("[Test III] Should prove that the attacker owns the stolen ETH", async function () {
      expect(await ethers.provider.getBalance(attacker.address)).to.be.gt(
        this.attackerInitialEthBalance
          .add(ART_PROFITS_DEPOSIT)
          .sub(ethers.utils.parseEther("0.2"))
      );
    });
  });
});
