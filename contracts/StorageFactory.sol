// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//when working with multiple files like these, be sure to keep the solidity versions in mind

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    //uint256 public favouriteNumber
    //type visibility name
    SimpleStorage[] public listOfSimpleStorageContracts; 

    function createSimpleStorageContract() public {
        //How does this contract know that SimpleStorage even exists?
        // One way is to have both the contracts in the same file
        // Or import the file 
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        // You need two things to interact with another contract - 
        // Address and ABI (Application Binary Interface)
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);

    }

    function sfRead(uint256 _simpleStorageIndex) public view returns(uint256){
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}