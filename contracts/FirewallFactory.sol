// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./BytecodeWhitelist.sol";

contract FirewallFactory is BytecodeWhitelist {
    /**
     * @param addr address if deployed contract
     * @param byteargs byte-array of args contract initiated by
     * @param deployedAt timestamp of deployment
     */
    struct Contract {
        address addr;
        bytes byteargs;
        uint256 deployedAt;
    }

    mapping (bytes32 => Contract[]) internal _contracts;

    /**
     * @dev deploys a specified bytecode and initiates constructor with byteargs if whitelisted
     * @param bytecode_ contract bytecode to be deployed
     * @param byteargs_ constructor args in byte-array must be initiated after deployment
     * @return address of deployed contract
     */
    function create(bytes memory bytecode_, bytes memory byteargs_) public returns (address) {
        require(isWhitelisted(bytecode_), "FirewallFactory: Bytecode is not permitted to deploy");

        bytes32 salt = keccak256(abi.encodePacked(bytecode_, byteargs_, block.timestamp));
        address deployed;
        assembly {
            deployed := create2(0, add(bytecode_, 32), mload(bytecode_), salt)
        }

        bytes32 _bytecodeHash = keccak256(bytecode_);
        _contracts[_bytecodeHash].push(Contract(deployed, byteargs_, block.timestamp));

        return deployed;
    }

    /**
     * @dev returns array of info related to all contracts of specified bytecode deployed
     * @param bytecode_ bytecode of contract deployed
     * @return array of deployment info
     */
    function contractsOf(bytes memory bytecode_) public view returns (Contract[] memory) {
        bytes32 _bytecodehash = keccak256(bytecode_);
        return _contracts[_bytecodehash];
    }
}