// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./BytecodeWhitelist.sol";

contract FirewallFactory is BytecodeWhitelist {
    /**
     * @dev deploys a specified bytecode and initiates constructor with byteargs if whitelisted
     * @param bytecode_ contract bytecode to be deployed
     * @param byteargs_ constructor args in byte-array must be initiated after deployment
     * @return address of deployed contract
     */
    function create(bytes memory bytecode_, bytes memory byteargs_) public returns (address) {
        require(isWhitelisted(bytecode_), "FirewallFactory: Bytecode is not permitted to deploy");

        bytes32 salt = keccak256(abi.encodePacked(bytecode_, byteargs_));
        address deployed;
        assembly {
            deployed := create2(0, add(bytecode_, 32), mload(bytecode_), salt)
        }

        return deployed;
    }
}