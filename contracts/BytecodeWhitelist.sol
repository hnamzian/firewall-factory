// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BytecodeWhitelist is Ownable {
    mapping(bytes32 => bool) internal _whitelistedBytecodes;

    function isWhitelisted(bytes memory bytecode_) public view returns (bool) {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));
        return _whitelistedBytecodes[_bytecodeHash];
    }

    function isWhitelisted(bytes32 bytecodeHash_) public view returns (bool) {
        return _whitelistedBytecodes[bytecodeHash_];
    }

    function whitelistBytecode(bytes memory bytecode_) public onlyOwner {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));

        require(!isWhitelisted(_bytecodeHash), "BytecodeWhitelist: Bytecode is already whitelisted");

        _whitelistedBytecodes[_bytecodeHash] = true;
    }

    function unwhitelistBytecode(bytes memory bytecode_) public onlyOwner {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));

        require(isWhitelisted(_bytecodeHash), "BytecodeWhitelist: Bytecode is not whitelisted");

        _whitelistedBytecodes[_bytecodeHash] = false;
    }
}