const { solidity } = require("ethereum-waffle");
const { expect } = require("chai").use(solidity);
const sample_bytecode = require("./bytecode");
const fs = require("fs");
const path = require("path");

const bytecodeWhitelistPath = path.join(
  __dirname,
  "..",
  "/artifacts/contracts/BytecodeWhitelist.sol/BytecodeWhitelist.json"
)
const bytecodeWhitelistFile = fs.readFileSync(bytecodeWhitelistPath);
const { abi, bytecode } = JSON.parse(bytecodeWhitelistFile.toString())

let factory;

describe("FirewallFactory", async () => {
  beforeEach(async () => {
    const FirewallFactory = await ethers.getContractFactory("FirewallFactory");
    factory = await FirewallFactory.deploy();
  });
  it("should deploy contract from bytecode", async () => {
    // deploy BytecodeWhitelist from FirewallFactory
    await factory.whitelistBytecode(bytecode);
    await factory.create(bytecode, "0x");
    const contracts = await factory.contractsOf(bytecode);

    // instantiate BytecodeWhitelist contract
    const provider = new ethers.providers.Web3Provider(hre.network.provider);
    const bytecodeWhitelist = new ethers.Contract(contracts[0].addr, abi, provider);

    // call owner() from BytecodeWhitelist
    const owner =  await bytecodeWhitelist.owner();

    // as another instance, verify isWhitelisted()
    const isWhitelisted = await bytecodeWhitelist["isWhitelisted(bytes)"](bytecode);
    
    // firewallFactory must be owner of BytecodeWhitelist as has created contract
    expect(owner).to.be.equal(factory.address); 

    // isWhitelisted must be false as we have not whitelisted any
    expect(isWhitelisted).to.be.equal(false);
  })
});
