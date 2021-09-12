// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BytecodeWhitelist is Ownable {
    // (bytecode_hash => isWhitelisted (bool))
    mapping(bytes32 => bool) internal _whitelistedBytecodes;

    /**
     * @dev checks if a specified bytecode has been whitelisted
     * @param bytecode_ byte-array bytecode
     * @return true if hash of bytecode_ has bee whitelisted otherwise, false
     */
    function isWhitelisted(bytes memory bytecode_) public view returns (bool) {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));
        return _whitelistedBytecodes[_bytecodeHash];
    }

    /**
     * @dev checks if a specified bytecode hash has been whitelisted
     * @param bytecodeHash_ bytes32 hash of bytecode
     * @return true if bytecodeHash_ has bee whitelisted otherwise, false
     */
    function isWhitelisted(bytes32 bytecodeHash_) public view returns (bool) {
        return _whitelistedBytecodes[bytecodeHash_];
    }

    /**
     * @dev adds hash of specified bytecode to whitelist
     * @param bytecode_ byte-array bytecode
     */
    function whitelistBytecode(bytes memory bytecode_) public onlyOwner {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));

        require(
            !isWhitelisted(_bytecodeHash),
            "BytecodeWhitelist: Bytecode is already whitelisted"
        );

        _whitelistedBytecodes[_bytecodeHash] = true;
    }

    /**
     * @dev removes hash of specified bytecode from whitelist
     * @param bytecode_ byte-array bytecode
     */
    function unwhitelistBytecode(bytes memory bytecode_) public onlyOwner {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));

        require(
            isWhitelisted(_bytecodeHash),
            "BytecodeWhitelist: Bytecode is not whitelisted"
        );

        _whitelistedBytecodes[_bytecodeHash] = false;
    }
}
