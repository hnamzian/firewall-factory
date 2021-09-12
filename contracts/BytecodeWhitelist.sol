// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BytecodeWhitelist is Ownable {
    mapping(bytes32 => bool) internal _whitelistedBytecodes;

    function isWhitelisted(bytes memory bytecode_) public view returns (bool) {
        bytes32 _bytecodeHash = keccak256(abi.encodePacked(bytecode_));
        return _whitelistedBytecodes[_bytecodeHash];
    }
}