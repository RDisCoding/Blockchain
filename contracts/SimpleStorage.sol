// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; //this is a comment

contract SimpleStorage{

    uint256 myFavouriteNumber; //0 by default when no value is assigned
    // by default visibility is internal 

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    //Person public pat = Person({favoriteNumber: 7, name: "Pat"});

    Person[] public listOfPeople; //dynamic array; [3] -> fixed size/static array

    mapping(string => uint256) public nameToFavouriteNumber; //mapping function -> default value is 0 for all keys

    // orange because we're actually updating and changing the state of the blockchain
    function store(uint256 _favouriteNumber) public virtual {
        myFavouriteNumber = _favouriteNumber;
        retrieve(); // here it'll cost gas to call this function
    }

    // blue because we're only reading something fromm this function
    // view -> disallows any updation of state
    // pure -> disallow updating and reading state/storage variables
    // this function call won't cost any gas unless called by a transaction function
    function retrieve() public view returns(uint256){
        return myFavouriteNumber;
    }

    //calldata, memory -> temporary variables made to store the value and couldn't be accessed again
    //memory - can be modified
    //calldata - cannot be modified
    //storage - permanent variables that can be modified
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        listOfPeople.push(Person(_favouriteNumber, _name));
        //mapping too
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}