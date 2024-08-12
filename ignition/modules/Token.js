const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const TokenModule = buildModule("TokenModule", (m) => {
  const token = m.contract("Token",["Coins", "CNS",8,1000]);

  return { token };
});

module.exports = TokenModule;