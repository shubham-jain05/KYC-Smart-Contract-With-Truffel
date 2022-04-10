const Kyc = artifacts.require("KYC");

module.exports = function (deployer) {
  deployer.deploy(kyc);
};
