//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructDefiner {
    struct MyStruct {
        uint256 someField;
        address someAddress;
        uint128 someOtherField;
        uint128 oneMoreField;
    }
}

contract Storage {
    StructDefiner.MyStruct[] internal structs;

    function getStructByIdx(uint256 idx) external view returns (bytes memory) {
        return abi.encode(structs[idx]);
    }
}

contract Controller {
    Storage internal storageContract;

    constructor(address _storage) {
        storageContract = Storage(_storage);
    }

    function getStruct(uint256 idx) public view returns (StructDefiner.MyStruct memory myStruct) {
        bytes memory _myStructBytes = storageContract.getStructByIdx(idx);
        assembly {
            // Convert bytes to MyStruct
            myStruct := mload(add(_myStructBytes, 32))
        }
    }
}
