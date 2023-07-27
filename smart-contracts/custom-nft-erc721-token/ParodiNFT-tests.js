const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Custom ERC721 Token Testing Suite", function () {
  // The accounts that we will use in our tests
  let deployer, user1, user2;

  // Constants representing the number of tokens to be minted by different users
  const DEPLOYER_MINT = 5;
  const USER1_MINT = 3;
  const MINT_PRICE = ethers.utils.parseEther("0.5");

  before(async function () {
    // In this setup block, we are deploying a smart contract and retrieving the signers

    // Retrieve signers (accounts) from the Ethereum node (here, hardhat)
    [deployer, user1, user2] = await ethers.getSigners();

    // Deploy the ERC721 contract from the deployer's address
    const ParodiNFTFactory = await ethers.getContractFactory(
      "ParodiNFT",
      deployer
    );
    this.nft = await ParodiNFTFactory.deploy();
  });

  describe("Minting Tests", function () {
    it("[Test I] Should allow deployer to mint tokens", async function () {
      // In this test, we simulate the process of the deployer minting tokens
      // We want to confirm that the mint function works correctly, and the deployer's balance reflects the correct number of minted tokens
      for (let i = 0; i < DEPLOYER_MINT; i++) {
        await this.nft.mint({ value: MINT_PRICE });
      }
    });

    it("[Test II] Should allow User1 to mint tokens", async function () {
      // This test is to confirm that other users (like user1) are also able to mint tokens
      for (let i = 0; i < USER1_MINT; i++) {
        await this.nft.connect(user1).mint({ value: MINT_PRICE });
      }
    });

    it("[Test III] Should correctly update the balance of the deployer after minting", async function () {
      expect(await this.nft.balanceOf(deployer.address)).to.equal(
        DEPLOYER_MINT
      );
    });

    it("[Test IV] Should correctly update the balance of User1 after minting", async function () {
      expect(await this.nft.balanceOf(user1.address)).to.equal(USER1_MINT);
    });

    it("[Test V] Should correctly reflect zero balance for User2 who has not minted any tokens", async function () {
      expect(await this.nft.balanceOf(user2.address)).to.equal(0);
    });
  });

  describe("Transfers Tests", function () {
    it("[Test VI] Should allow User1 to transfer a token to User2", async function () {
      await this.nft
        .connect(user1)
        .transferFrom(user1.address, user2.address, 6);
    });

    it("[Test VII] Should correctly update ownership after User1 transfers a token to User2", async function () {
      expect(await this.nft.ownerOf(6)).to.equal(user2.address);
    });

    it("[Test VIII] Should allow Deployer to approve User1 for transferring a token", async function () {
      await this.nft.approve(user1.address, 3);
    });

    it("[Test IX] Should correctly reflect approval status for a token", async function () {
      expect(await this.nft.getApproved(3)).to.equal(user1.address);
    });

    it("[Test X] Should allow User1 to transfer an approved token from the Deployer to themselves", async function () {
      await this.nft
        .connect(user1)
        .transferFrom(deployer.address, user1.address, 3);
    });

    it("[Test XI] Should correctly update ownership after User1 transfers an approved token", async function () {
      expect(await this.nft.ownerOf(3)).to.equal(user1.address);
    });

    it("[Test XII] Should correctly update the balances after transfers", async function () {
      // Check all account balances after the transfer operation to ensure the state is updated correctly
      expect(await this.nft.balanceOf(deployer.address)).to.equal(
        DEPLOYER_MINT - 1
      );
      expect(await this.nft.balanceOf(user1.address)).to.equal(
        USER1_MINT + 1 - 1
      );
      expect(await this.nft.balanceOf(user2.address)).to.equal(1);
    });
  });
});
