//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    mapping(address => uint256) values;

    function getValue(address _addr) public view returns (bytes32 storagePointer) {
        assembly {
            // Load the slot of the mapping (_slot := keccak256(_values_slot))
            let slot := sload(values.slot)

            // Calculate the storage pointer for the given key (_storagePointer := keccak256(_slot, _key))
            storagePointer := keccak256(slot, _addr)
        }
    }
}