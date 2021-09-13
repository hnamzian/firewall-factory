# Firewall Factory
FirewallFactory is simple smart contract deploys bytescodes accompanied by constructor args into EVM based blockchain.
Only whitelisted bytecodes are permitted to be deployed. Firewall owner has permission to whitelist bytecodes or even
remove them from whitelist. Anyone can try deploying a whitelisted bytecode.

# Install dependencies
To install all dependencies:
```
npm i
```

# Compile Smart Contract
To compile smart contract:
```
npm run compile
```

# Run Tests
There are some test routins provided in JS. Tests will be run on hardhat in-process network by default.
```
npm run test
```