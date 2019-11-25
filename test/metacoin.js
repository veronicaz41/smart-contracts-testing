// From https://github.com/truffle-box/metacoin-box

const MetaCoin = artifacts.require("MetaCoin");

contract("MetaCoin", accounts => {
  it("should put 10000 MetaCoin in the first account", async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const balance = await metaCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });

  it("should call a function that depends on a linked library", async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const metaCoinBalance = (
      await metaCoinInstance.getBalance.call(accounts[0])
    ).toNumber();
    const metaCoinEthBalance = (
      await metaCoinInstance.getBalanceInEth.call(accounts[0])
    ).toNumber();

    assert.equal(
      metaCoinEthBalance,
      2 * metaCoinBalance,
      "Library function returned unexpected function, linkage may be broken"
    );
  });

  it("should send coin correctly", async () => {
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (
      await metaCoinInstance.getBalance.call(accountOne)
    ).toNumber();
    const accountTwoStartingBalance = (
      await metaCoinInstance.getBalance.call(accountTwo)
    ).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await metaCoinInstance.sendCoin(accountTwo, amount, {from: accountOne});

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (
      await metaCoinInstance.getBalance.call(accountOne)
    ).toNumber();
    const accountTwoEndingBalance = (
      await metaCoinInstance.getBalance.call(accountTwo)
    ).toNumber();

    assert.equal(
      accountOneEndingBalance,
      accountOneStartingBalance - amount,
      "Amount wasn't correctly taken from the sender"
    );
    assert.equal(
      accountTwoEndingBalance,
      accountTwoStartingBalance + amount,
      "Amount wasn't correctly sent to the receiver"
    );
  });

  // Test require() revert
  // can use @openzeppelin/test-helpers expectRevert
  it("should revert when sendCoin amount exceeds account balance", async () => {
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Make transaction from first account to second.
    // 20000 > 10000 (accountOne balance)
    const amount = 20000;
    try {
      await metaCoinInstance.sendCoin(accountTwo, amount, {
        from: accountOne
      });
    } catch (error) {
      // error.message
      // Returned error: VM Exception while processing transaction: revert SendCoin: amount exceeds account balance -- Reason given: SendCoin: amount exceeds account balance.
      assert.match(
        error.message,
        /Returned error: VM Exception while processing transaction: (revert )?/,
        "Wrong kind of exception received"
      );
      const actualError = error.message.replace(
        /Returned error: VM Exception while processing transaction: (revert .*) -- Reason given: /,
        ""
      );
      expect(actualError).to.equal(
        "SendCoin: amount exceeds account balance.",
        "Exception reason given is wrong"
      );
      return;
    }
  });

  // Test events
  // can use @openzeppelin/test-helpers expectEvent
  it("should emit Transfer event", async () => {
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Make transaction from first account to second.
    const amount = 10;
    let tx = await metaCoinInstance.sendCoin(accountTwo, amount, {
      from: accountOne
    });

    // Checking event
    assert.equal(tx.logs[0].event, "Transfer", "Expected Transfer event");
  });
});
