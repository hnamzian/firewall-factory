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
  it("should revert whitelisting bytecode by user except owner", async () => {
    const [_, user] = await ethers.getSigners();
    await expect(bytecodeWhitelist.connect(user).whitelistBytecode(sample_bytecode))
      .to.be.revertedWith("");
  })
  it("should unwhitelist whitelisted bytecode", async () => {
    await bytecodeWhitelist.whitelistBytecode(sample_bytecode);
    await bytecodeWhitelist.unwhitelistBytecode(sample_bytecode);
    const isWhitelisted = await bytecodeWhitelist["isWhitelisted(bytes)"](sample_bytecode);
    expect(isWhitelisted).to.be.equal(false);
  })
  it("should revert unwhitelisting not-whitelisted bytecode", async () => {
    await bytecodeWhitelist.whitelistBytecode(sample_bytecode);
    await bytecodeWhitelist.unwhitelistBytecode(sample_bytecode);
    await expect(bytecodeWhitelist.unwhitelistBytecode(sample_bytecode))
      .to.be.revertedWith("BytecodeWhitelist: Bytecode is not whitelisted")
  })
  it("should revert unwhitelisting bytecode by user except owner", async () => {
    const [_, user] = await ethers.getSigners();
    await expect(bytecodeWhitelist.connect(user).unwhitelistBytecode(sample_bytecode))
      .to.be.revertedWith("");
  })
});
