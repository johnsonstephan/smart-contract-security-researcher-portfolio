const { ethers } = require("hardhat");
const { expect } = require("chai");

// Custom ERC20 Token Testing Suite
describe("Custom ERC20 Token Testing", function () {
  let deployer, user1, user2, user3;

  // Define constants for minting and transfers
  const DEPLOYER_MINT = ethers.utils.parseEther("50000");
  const USERS_MINT = ethers.utils.parseEther("10000");
  const TRANSFER_USER2_TO_USER3 = ethers.utils.parseEther("200");
  const TRANSFER_USER3_TO_USER1 = ethers.utils.parseEther("2000");

  // Perform deployment and minting operations
  before(async function () {
    // Get signers
    [deployer, user1, user2, user3] = await ethers.getSigners();

    // Deployment: Deploy the JohnsonToken contract, from the deployer
    const JohnsonTokenFactory = await ethers.getContractFactory(
      "JohnsonToken",
      deployer
    );
    this.token = await JohnsonTokenFactory.deploy();
  });

  // Test minting operations
  it("should mint tokens to deployer and users", async function () {
    // Minting Operations: Mint tokens to the deployer and users
    // [a] 50K tokens to the deployer
    await this.token.mint(deployer.address, DEPLOYER_MINT);

    // [b] 10K tokens to user1
    await this.token.mint(user1.address, USERS_MINT);

    // [c] 10K tokens to user2
    await this.token.mint(user2.address, USERS_MINT);

    // [d] 10K tokens to user3
    await this.token.mint(user3.address, USERS_MINT);

    // Test: Verify minting balances for each user and the deployer
    // [a] deployer
    expect(await this.token.balanceOf(deployer.address)).to.equal(
      DEPLOYER_MINT
    );
    // [b] users
    expect(await this.token.balanceOf(user1.address)).to.equal(USERS_MINT);
    expect(await this.token.balanceOf(user2.address)).to.equal(USERS_MINT);
    expect(await this.token.balanceOf(user3.address)).to.equal(USERS_MINT);
  });

  // Test token transfers and approvals
  it("should transfer tokens and grant approvals", async function () {
    // Transfer: 200 tokens from user2 to user3
    await this.token
      .connect(user2)
      .transfer(user3.address, TRANSFER_USER2_TO_USER3);

    // Approve: From user3, approve user1 to spend 2K tokens
    await this.token
      .connect(user3)
      .approve(user1.address, TRANSFER_USER3_TO_USER1);

    // Testing: Verify user1's allowance, as granted by user3
    expect(await this.token.allowance(user3.address, user1.address)).to.equal(
      TRANSFER_USER3_TO_USER1
    );

    // Transfer: From user1, transfer 2K tokens from user3 to user1, using transferFrom()
    await this.token
      .connect(user1)
      .transferFrom(user3.address, user1.address, TRANSFER_USER3_TO_USER1);

    // Testing: Verify final balances of user1, user2 and user3 after the transfers
    // [a] user1
    expect(await this.token.balanceOf(user1.address)).to.equal(
      USERS_MINT.add(TRANSFER_USER3_TO_USER1)
    );
    // [b] user2
    expect(await this.token.balanceOf(user2.address)).to.equal(
      USERS_MINT.sub(TRANSFER_USER2_TO_USER3)
    );
    // [c] user3
    expect(await this.token.balanceOf(user3.address)).to.equal(
      USERS_MINT.add(TRANSFER_USER2_TO_USER3).sub(TRANSFER_USER3_TO_USER1)
    );
  });
});
