const token = artifacts.require("ERC20");
const transferTx = artifacts.require("TransferTx");

module.exports = function (deployer) {
  const token1 = deployer.deploy(token);
  deployer.deploy(transferTx, '0x2ECCC59B23c4055FfAEcF09347E23637B7fCBdE7');

};
