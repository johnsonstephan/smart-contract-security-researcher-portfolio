const { ethers } = require("hardhat");
const { expect } = require("chai");

// This test suite aims to test the functionality of a smart contract called "Receipt Token"
// It simulates interaction with the contract using mainnet tokens (AAVE, UNI, WETH) and their respective holders
describe("Receipt Token Testing Suite", function () {
  let deployer;

  // Define the mainnet token addresses for AAVE, UNI, and WETH
  const AAVE_TOKEN_ADDRESS = "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9";
  const UNI_TOKEN_ADDRESS = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984";
  const WETH_TOKEN_ADDRESS = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";

  // Define the mainnet holder addresses for AAVE, UNI, and WETH
  const AAVE_OWNER = "0x61b0E6B68184eb0316B1285C4E76a15bfC7CD857";
  const UNI_OWNER = "0x47173B170C64d16393a52e6C480b3Ad8c302ba1e";
  const WETH_OWNER = "0x438fd34EAB0E80814a231a983D8BfAf507ae16D4";

  // Define a constant amount (5 ETH) for funding the token holders' accounts
  // This will be used to pay for gas fees and enable them to send transactions
  const ETH_FUNDING = ethers.utils.parseEther("5");

  // This 'before' hook runs before all the tests and sets up the required test environment
  before(async function () {
    // Load the deployer account (the account that will deploy the smart contract)
    [deployer] = await ethers.getSigners();

    // Load the mainnet token contracts (AAVE, UNI, WETH) using the OpenZeppelin ERC20 interface
    // These contract instances will be referred to as 'this.aave', 'this.uni', and 'this.weth' respectively
    this.aave = await ethers.getContractAt(
      "@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20",
      AAVE_TOKEN_ADDRESS
    );
    this.uni = await ethers.getContractAt(
      "@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20",
      UNI_TOKEN_ADDRESS
    );
    this.weth = await ethers.getContractAt(
      "@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20",
      WETH_TOKEN_ADDRESS
    );

    // Load the mainnet token holders (AAVE_OWNER, UNI_OWNER, WETH_OWNER) as impersonated signers
    // These signer instances will be referred to as 'this.aaveOwner', 'this.uniOwner', and 'this.wethOwner' respectively
    this.aaveOwner = await ethers.getImpersonatedSigner(AAVE_OWNER);
    this.uniOwner = await ethers.getImpersonatedSigner(UNI_OWNER);
    this.wethOwner = await ethers.getImpersonatedSigner(WETH_OWNER);

    // Send ETH to the token holders (AAVE_OWNER, UNI_OWNER, WETH_OWNER) so they can pay for gas and send transactions
    await deployer.sendTransaction({
      to: this.aaveOwner.address,
      value: ETH_FUNDING,
    });
    await deployer.sendTransaction({
      to: this.uniOwner.address,
      value: ETH_FUNDING,
    });
    await deployer.sendTransaction({
      to: this.wethOwner.address,
      value: ETH_FUNDING,
    });

    // Get the initial token balances of the token holders (AAVE_OWNER, UNI_OWNER, WETH_OWNER)
    // These balances will be referred to as 'this.startingAAVEBalance', 'this.startingUNIBalance', and 'this.startingWETHBalance' respectively
    this.startingAAVEBalance = await this.aave.balanceOf(
      this.aaveOwner.address
    );
    this.startingUNIBalance = await this.uni.balanceOf(this.uniOwner.address);
    this.startingWETHBalance = await this.weth.balanceOf(
      this.wethOwner.address
    );

    // Log the initial token balances to the console for potential debugging purposes
    console.log(
      "The AAVE Owner's AAVE Balance is: ",
      ethers.utils.formatUnits(this.startingAAVEBalance)
    );
    console.log(
      "The UNI Owner's UNI Balance is: ",
      ethers.utils.formatUnits(this.startingUNIBalance)
    );
    console.log(
      "The WETH Owner's WETH Balance is: ",
      ethers.utils.formatUnits(this.startingWETHBalance)
    );
  });

  // Test I: Deploy the depository contract and load receipt tokens
  it("[Test I] Should deploy depository and load receipt tokens", async function () {
    // Objective: Deploy the TokensDepository contract with the supported assets
    // Get the contract factory for the TokensDepository and deploy it using the deployer account
    const TokensDepositoryFactory = await ethers.getContractFactory(
      "contracts/erc20-2/TokensDepository.sol:TokensDepository",
      deployer
    );

    // Deploy the contract with the constructor arguments for the supported assets (AAVE, UNI, WETH)
    this.depository = await TokensDepositoryFactory.deploy(
      AAVE_TOKEN_ADDRESS,
      UNI_TOKEN_ADDRESS,
      WETH_TOKEN_ADDRESS
    );

    // Objective: Load the corresponding receipt tokens into objects under `this` (e.g., this.rAave, this.rUni, this.rWeth)
    // rAAVE
    this.rAAVE = await ethers.getContractAt(
      "rToken",
      await this.depository.receiptTokens(AAVE_TOKEN_ADDRESS)
    );
    // rUNI
    this.rUNI = await ethers.getContractAt(
      "rToken",
      await this.depository.receiptTokens(UNI_TOKEN_ADDRESS)
    );
    // rWETH
    this.rWETH = await ethers.getContractAt(
      "rToken",
      await this.depository.receiptTokens(WETH_TOKEN_ADDRESS)
    );
  });

  // Test II: Perform deposit token tests
  it("[Test II] Should approve user spending, deposit tokens, and mint receipt tokens", async function () {
    // Deposit 12 AAVE tokens from the AAVE holder
    // Define the amount of AAVE to deposit (12 AAVE), considering the 18 decimals
    this.aaveAmount = ethers.utils.parseEther("12");
    // Approve the depository to spend the AAVE tokens on behalf of the AAVE holder
    await this.aave
      .connect(this.aaveOwner)
      .approve(this.depository.address, this.aaveAmount);
    // Deposit the AAVE tokens to the depository contract on behalf of the AAVE holder
    await this.depository
      .connect(this.aaveOwner)
      .deposit(AAVE_TOKEN_ADDRESS, this.aaveAmount);

    // Deposit 4533 UNI tokens from the UNI holder
    this.uniAmount = ethers.utils.parseEther("4533");
    // Approve the depository to spend the UNI tokens on behalf of the UNI holder
    await this.uni
      .connect(this.uniOwner)
      .approve(this.depository.address, this.uniAmount);
    // Deposit the UNI tokens to the depository contract on behalf of the UNI holder
    await this.depository
      .connect(this.uniOwner)
      .deposit(UNI_TOKEN_ADDRESS, this.uniAmount);

    // Deposit 27 WETH tokens from the WETH holder
    this.wethAmount = ethers.utils.parseEther("27");
    // Approve the depository to spend the WETH tokens on behalf of the WETH holder
    await this.weth
      .connect(this.wethOwner)
      .approve(this.depository.address, this.wethAmount);
    // Deposit the WETH tokens to the depository contract on behalf of the WETH holder
    await this.depository
      .connect(this.wethOwner)
      .deposit(WETH_TOKEN_ADDRESS, this.wethAmount);

    // Objective: Check that the tokens were successfully transferred to the depository (AAVE, UNI, WETH)
    expect(await this.aave.balanceOf(this.depository.address)).to.be.equal(
      this.aaveAmount
    );
    expect(await this.uni.balanceOf(this.depository.address)).to.be.equal(
      this.uniAmount
    );
    expect(await this.weth.balanceOf(this.depository.address)).to.be.equal(
      this.wethAmount
    );

    // Objective: Check that the right amount of receipt tokens were minted (rAAVE, rUNI, rWETH)
    expect(await this.rAave.balanceOf(this.aaveOwner.address)).to.be.equal(
      this.aaveAmount
    );
    expect(await this.rUni.balanceOf(this.uniOwner.address)).to.be.equal(
      this.uniAmount
    );
    expect(await this.rWeth.balanceOf(this.wethOwner.address)).to.be.equal(
      this.wethAmount
    );
  });

  // Test III: Perform withdraw token tests
  it("[Test III] Should withdraw underlying tokens and burn receipt tokens", async function () {
    // Objective: Withdraw ALL the Tokens (AAVE, UNI, WETH)
    await this.depository
      .connect(this.aaveOwner)
      .withdraw(AAVE_TOKEN_ADDRESS, this.aaveAmount);
    await this.depository
      .connect(this.uniOwner)
      .withdraw(UNI_TOKEN_ADDRESS, this.uniAmount);
    await this.depository
      .connect(this.wethOwner)
      .withdraw(WETH_TOKEN_ADDRESS, this.wethAmount);

    // Objective: Check that the right amount of tokens were withdrawn (AAVE, UNI, WETH)
    // Depositors should get back their original token amounts
    expect(await this.aave.balanceOf(this.aaveOwner.address)).to.be.equal(
      this.startingAAVEBalance
    );
    expect(await this.uni.balanceOf(this.uniOwner.address)).to.be.equal(
      this.startingUNIBalance
    );
    expect(await this.weth.balanceOf(this.wethOwner.address)).to.be.equal(
      this.startingWETHBalance
    );

    // Objective: Check that the right amount of receipt tokens were burned (rAAVE, rUNI, rWETH)
    // The receipt token balances should be zero after withdrawal
    expect(await this.rAave.balanceOf(this.aaveOwner.address)).to.be.equal(0);
    expect(await this.rUni.balanceOf(this.uniOwner.address)).to.be.equal(0);
    expect(await this.rWeth.balanceOf(this.wethOwner.address)).to.be.equal(0);
  });
});
