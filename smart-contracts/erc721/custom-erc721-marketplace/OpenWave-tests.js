const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Custom ERC721 Marketplace Testing Suite", function () {
  let deployer, user1, user2, user3;
  const PIXEL_SAGA_NFT_PRICE = ethers.utils.parseEther("2.5");
  const BEYOND_INFINITY_NFT_PRICE = ethers.utils.parseEther("4");

  before(async function () {
    [deployer, user1, user2, user3] = await ethers.getSigners();
  });

  // Test I: User1 should be able to create a NFT collection
  it("[Test I] Should allow User1 to create a NFT collection", async function () {
    let NFTFactory = await ethers.getContractFactory(
      "contracts/utils/SampleERC721.sol:SampleERC721",
      user1
    );
    this.pixelSagaNFT = await NFTFactory.deploy("Pixel Saga", "PIX", 1000);
    await this.pixelSagaNFT.mintBulk(30);
  });

  // Test II: User1's balance should equal to 30 after minting 30 Pixel Saga NFTs
  it("[Test II] Should have User1's balance equal to 30 after minting 30 Pixel Saga NFTs", async function () {
    expect(await this.pixelSagaNFT.balanceOf(user1.address)).to.be.equal(30);
  });

  // Test III: User3 should be able to create a NFT collection
  it("[Test III] Should allow User3 to create a NFT collection", async function () {
    let NFTFactory = await ethers.getContractFactory("SampleERC721", user3);
    this.beyondInfinityNFT = await NFTFactory.deploy(
      "Beyond Infinity",
      "BIO",
      10000
    );
    await this.beyondInfinityNFT.mintBulk(120);
  });

  // Test IV: User3's balance should equal to 120 after minting 120 Beyond Infinity NFTs
  it("[Test IV] Should have User3's balance equal to 120 after minting 120 Beyond Infinity NFTs", async function () {
    expect(await this.beyondInfinityNFT.balanceOf(user3.address)).to.be.equal(
      120
    );
  });

  // Test V: Storing initial balance of all users before test run
  it("[Test V] Should store the initial balance of all users before test run", async function () {
    this.user1InitialBalance = await ethers.provider.getBalance(user1.address);
    this.user2InitialBalance = await ethers.provider.getBalance(user2.address);
    this.user3InitialBalance = await ethers.provider.getBalance(user3.address);
  });

  // Test VI: Deploying the OpenWave marketplace
  it("[Test VI] Should deploy OpenWave marketplace", async function () {
    let MarketplaceFactory = await ethers.getContractFactory(
      "OpenWave",
      deployer
    );
    this.marketplace = await MarketplaceFactory.deploy();
  });

  // Test VII: User1 lists Pixel Saga NFT tokens
  it("[Test VII] Should allow User1 to list Pixel Saga NFT tokens", async function () {
    for (let i = 1; i <= 10; i++) {
      await this.pixelSagaNFT.approve(this.marketplace.address, i);
      await this.marketplace
        .connect(user1)
        .listItem(this.pixelSagaNFT.address, i, PIXEL_SAGA_NFT_PRICE);
    }
  });

  // Test VIII: Marketplace should own 10 Pixel Saga NFT tokens after listing
  it("[Test VIII] Should make the marketplace own 10 Pixel Saga NFT tokens after listing", async function () {
    expect(
      await this.pixelSagaNFT.balanceOf(this.marketplace.address)
    ).to.be.equal(10);
  });

  // Test IX: Check the last Pixel Saga NFT listed
  it("[Test IX] Should correctly store the information for the last Pixel Saga NFT listed", async function () {
    let lastItem = await this.marketplace.listedItems(10);
    expect(lastItem.itemId).to.be.equal(10);
    expect(lastItem.collection).to.be.equal(this.pixelSagaNFT.address);
    expect(lastItem.tokenId).to.be.equal(10);
    expect(lastItem.price).to.be.equal(PIXEL_SAGA_NFT_PRICE);
    expect(lastItem.seller).to.be.equal(user1.address);
    expect(lastItem.isSold).to.be.equal(false);
  });

  // Test X: User3 lists Beyond Infinity NFT tokens
  it("[Test X] Should allow User3 to list Beyond Infinity NFT tokens", async function () {
    for (let i = 1; i <= 5; i++) {
      await this.beyondInfinityNFT.approve(this.marketplace.address, i);
      await this.marketplace
        .connect(user3)
        .listItem(this.beyondInfinityNFT.address, i, BEYOND_INFINITY_NFT_PRICE);
    }
  });

  // Test XI: Marketplace should own 5 Beyond Infinity NFT tokens after listing
  it("[Test XI] Should make the marketplace own 5 Beyond Infinity NFT tokens after listing", async function () {
    expect(
      await this.beyondInfinityNFT.balanceOf(this.marketplace.address)
    ).to.be.equal(5);
  });

  // Test XII: Check the last Beyond Infinity NFT listed
  it("[Test XII] Should correctly store the information for the last Beyond Infinity NFT listed", async function () {
    let lastItem = await this.marketplace.listedItems(15);
    expect(lastItem.itemId).to.be.equal(15);
    expect(lastItem.collection).to.be.equal(this.beyondInfinityNFT.address);
    expect(lastItem.tokenId).to.be.equal(5);
    expect(lastItem.price).to.be.equal(BEYOND_INFINITY_NFT_PRICE);
    expect(lastItem.seller).to.be.equal(user3.address);
    expect(lastItem.isSold).to.be.equal(false);
  });

  // Test case XIII: Attempting to purchase non-existing NFT token
  it("[Test XIII] Should not allow the purchase of a non-existing NFT token", async function () {
    // User2 attempts to purchase a non-existing item with ID 250
    // Since there's no such item in the marketplace, we expect this transaction to fail
    await expect(
      this.marketplace.connect(user2).purchase(250)
    ).to.be.revertedWith("Incorrect _itemID");
  });

  // Test case XIV: Attempting to purchase without sending ETH
  it("[Test XIV] Should not allow purchasing an NFT token without sending the correct amount of ETH", async function () {
    // User2 attempts to purchase item 4 without sending any ETH
    // As the transaction needs the correct amount of ETH to be successful, we expect it to fail
    await expect(
      this.marketplace.connect(user2).purchase(4)
    ).to.be.revertedWith("Incorrect price sent for the purchase");
  });

  // Test case XV: Making a successful purchase
  it("[Test XV] Should allow the purchase of an NFT token when the correct amount of ETH is sent", async function () {
    // User2 attempts to purchase item 4, sending the correct amount of ETH for the Pixel Saga NFT token
    // This transaction should be successful as User2 is sending the required ETH
    await this.marketplace
      .connect(user2)
      .purchase(4, { value: PIXEL_SAGA_NFT_PRICE });

    // After the successful purchase, User2 should be the owner of the Pixel Saga NFT token with ID 4
    expect(await this.pixelSagaNFT.ownerOf(4)).to.be.equal(user2.address);
  });

  // Test case XVI: Attempting to purchase an already sold NFT token
  it("[Test XVI] Should not allow the purchase of an NFT token that has already been sold", async function () {
    // User2 attempts to purchase the Pixel Saga NFT token with ID 4 again
    // As this token has already been sold to User2, we expect this transaction to fail
    await expect(
      this.marketplace
        .connect(user2)
        .purchase(4, { value: PIXEL_SAGA_NFT_PRICE })
    ).to.be.revertedWith(
      "This cannot be purchased, as the item is already sold"
    );
  });

  // Test case XVII: Validating the correct transfer of funds after a sale
  it("[Test XVII] Should correctly transfer funds to the seller after a successful sale", async function () {
    // After the successful sale of the Pixel Saga NFT token, we verify that User1 (the seller) has received the correct amount of ETH
    // We subtract a transaction fee (0.25 ETH) from the expected amount to account for transaction costs on the Ethereum network
    // As the transaction fee is not exact, we use greater than or equal to
    expect(await ethers.provider.getBalance(user1.address)).greaterThanOrEqual(
      this.user1InitialBalance
        .add(PIXEL_SAGA_NFT_PRICE)
        .sub(ethers.utils.parseEther("0.25"))
    );
  });

  // Test case XVIII: Successfully purchasing another NFT token
  it("[Test XVIII] Should allow the purchase of a different NFT token", async function () {
    // User2 attempts to purchase the Beyond Infinity NFT token with ID 1 (listed as item 13 in the marketplace), sending the correct amount of ETH
    // This transaction should be successful as User2 is sending the required ETH
    await this.marketplace
      .connect(user2)
      .purchase(13, { value: BEYOND_INFINITY_NFT_PRICE });

    // After the successful purchase, User2 should be the owner of the Beyond Infinity NFT token with ID 1
    expect(await this.beyondInfinityNFT.ownerOf(1)).to.be.equal(user2.address);
  });

  // Test case XIX: Validating the correct transfer of funds after a different sale
  it("[Test XIX] Should correctly transfer funds to the seller after a different successful sale", async function () {
    // After the successful sale of the Beyond Infinity NFT token, we verify that User3 (the seller) has received the correct amount of ETH
    // We subtract a transaction fee (0.25 ETH) from the expected amount to account for transaction costs on the Ethereum network
    // As the transaction fee is not exact, we use greater than or equal to
    expect(await ethers.provider.getBalance(user3.address)).greaterThanOrEqual(
      this.user3InitialBalance
        .add(BEYOND_INFINITY_NFT_PRICE)
        .sub(ethers.utils.parseEther("0.25"))
    );
  });

  // Test case XX: Conducting a successful purchase transaction with a different token
  it("[Test XX] Should facilitate a successful purchase transaction of a Beyond Infinity token", async function () {
    // Here, User2 is making a purchase of a Beyond Infinity token listed on the marketplace.
    // We use the connect function to indicate that User2 is initiating this transaction.
    // The value provided corresponds to the listing price of the Beyond Infinity token.
    await this.marketplace
      .connect(user2)
      .purchase(13, { value: BEYOND_INFINITY_NFT_PRICE });
  });

  // Test case XXI: Verifying the ownership of the token after purchase
  it("[Test XXI] Should verify the transfer of token ownership after a successful purchase", async function () {
    // After the purchase transaction, we confirm that User2 now owns the purchased Beyond Infinity token.
    // The function ownerOf(1) queries the owner of token ID 1 in the Beyond Infinity smart contract.
    // We then assert that the owner's address matches User2's address, hence verifying successful transfer of ownership.
    expect(await this.beyondInfinityNFT.ownerOf(1)).to.be.equal(user2.address);
  });

  // Test case XXII: Validating the correct transfer of funds after a different sale
  it("[Test XXII] Should correctly transfer funds to the seller after a different successful sale", async function () {
    // After the successful sale of the Beyond Infinity token, we verify that User3 (the seller) has received the correct amount of ETH.
    // We subtract a transaction fee (0.25 ETH) from the expected amount to account for transaction costs on the Ethereum network.
    // As the transaction fee is not exact, we use greater than or equal to.
    expect(await ethers.provider.getBalance(user3.address)).greaterThanOrEqual(
      this.user3InitialBalance
        .add(BEYOND_INFINITY_NFT_PRICE)
        .sub(ethers.utils.parseEther("0.25"))
    );
  });
});
