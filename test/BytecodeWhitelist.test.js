const { solidity } = require("ethereum-waffle");
const { expect } = require("chai").use(solidity);
const sample_bytecode = require("./bytecode");

let bytecodeWhitelist;

describe("BytecodeWhitelist", async () => {
  beforeEach(async () => {
    const BytecodeWhitelist = await ethers.getContractFactory("BytecodeWhitelist");
    bytecodeWhitelist = await BytecodeWhitelist.deploy();
  });
  it("should whitelist sample_bytecode", async () => {
    await bytecodeWhitelist.whitelistBytecode(sample_bytecode);
    const isWhitelisted = await bytecodeWhitelist["isWhitelisted(bytes)"](sample_bytecode);
    expect(isWhitelisted).to.be.equal(true);
  })
  it("should revert whitelisting existing bytecode", async () => {
    await bytecodeWhitelist.whitelistBytecode(sample_bytecode);
    await expect(bytecodeWhitelist.whitelistBytecode(sample_bytecode))
      .to.be.revertedWith("BytecodeWhitelist: Bytecode is already whitelisted")
  })
});
