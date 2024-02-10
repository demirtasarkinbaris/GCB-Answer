//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructDefiner {
    struct MyStruct {
        uint256 someField;
        address someAddress;
        uint128 someOtherField;
        uint128 oneMoreField;
    }
    
    function toBytes(MyStruct memory _struct) public pure returns (bytes memory) {
        bytes memory result = new bytes(48); // Total size of the struct = 32 (uint256) + 20 (address) + 16 (2 * uint128)
        assembly {
            mstore(add(result, 32), _struct.someField)
            mstore(add(result, 64), _struct.someAddress)
            mstore(add(result, 84), _struct.someOtherField)
            mstore(add(result, 100), _struct.oneMoreField)
        }
        return result;
    }
    
    function fromBytes(bytes memory _data) public pure returns (MyStruct memory) {
        MyStruct memory _struct;
        assembly {
            _struct.someField := mload(add(_data, 32))
            _struct.someAddress := mload(add(_data, 52))
            _struct.someOtherField := mload(add(_data, 72))
            _struct.oneMoreField := mload(add(_data, 88))
        }
        return _struct;
    }
}

contract Storage {
    StructDefiner.MyStruct[] internal structs;
    
    function getStructByIdx(uint256 idx) external view returns (bytes memory) {
        require(idx < structs.length, "Index out of bounds");
        return StructDefiner.toBytes(structs[idx]);
    }
}

contract Controller {
    Storage internal storageContract;
    
    constructor(address _storage) {
        storageContract = Storage(_storage);
    }
    
    function getStruct(uint256 idx) public returns (StructDefiner.MyStruct memory) {
        bytes memory _myStruct = storageContract.getStructByIdx(idx);
        return StructDefiner.fromBytes(_myStruct);
    }
}