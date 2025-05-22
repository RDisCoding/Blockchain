//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage{

    function sayHi() public pure returns(string memory){
        return "Hi!!";
    }

    function store(uint256 _newNumber) public override {
        myFavouriteNumber = _newNumber +5;
    }
}