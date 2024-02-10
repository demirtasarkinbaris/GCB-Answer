//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    mapping(address => uint256) values;

    function getValue(address _addr) public view returns (bytes32 storagePointer) {
        assembly {
            // Calculate the storage slot address by multiplying _addr with 32
            let slot := mul(_addr, 0x20)

            // Load the value at the calculated storage slot
            storagePointer := sload(slot)
        }
    }
}