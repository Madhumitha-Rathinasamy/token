const token = artifacts.require("ERC20");

module.exports = function (deployer) {
  deployer.deploy(token);
};