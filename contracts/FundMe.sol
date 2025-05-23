//Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
// This imports our custom library

error NotOwner(); // creating custom error and using wherever necessary to save gas

contract FundMe{
    using PriceConverter for uint256; // attaching our library to all the uint256

    // use constant keyword for the variables which are declared at compile time and never change their value
    // this is done to save gas/money on calling the contract -> Gas Optimization
    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    // this is also set only one time but is used in the constructor
    //immutable -> used for deployment time variables
    //Must be assigned in the constructor, not at declaration (can also be assigned inline in declaration starting Solidity 0.8.19)
    // used to save gas/money
    //the main idea is instead of storing these variables into storage slots
    //we store them directly into the bytecode of the contract 
    address public immutable i_owner;

    // will be immediately called
    // we'll use it to assign the owner when contract is deployed
    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{ 
        //Allows a user to send $
        //Have a minimum $ sent

        //How to send ETH through this contract?

        //add the payable keyword to make the function be capable of transacting funds/eth
        //the address is what receives the funds

        //How to have a min sent value?

        //require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH");
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
        //when using library function, the 1st parameter of the function 
        //is always the one to which the function is attached to and takes its type
        //so msg.value is a uint256 here so it can call all the library fn and is taken as the first input
        
        // 1e18 = 1eth
        //msg.value -> globally available variable which gets number of wei sent with the message
        // if the condition is not met, the function reverts back and shows the following message "didn't send enough ETH"

        //What is a revert?
        //Undo any actions that have been done, and sends the remaining gas back
        //Even if the function gets reverted, the gas will still be spent, its just the remaining amt of gas will be refunded if the user specified any limit on the gas to begin with for the function to execute

        funders.push(msg.sender); //msg.sender is another global variable
        //push the address of the user who called the function into our array so that we can know who sent them ETH
        //The push function pushes the data onto the end of an array. The variable "funders" is an array
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        //purpose - to send funds into the owners wallet

        //only owner can withdraw
        //can also just use a modifier instead
        //require(msg.sender == owner, "Not the owner");

        // use for loop and reset the mapping
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; 
        }

        //resetting the funders array using new keyword
        funders = new address[](0); 

        //to actually send eth there are 3 ways-
        //transfer, send and call

        //transfer -> throws error on hitting gas limit, automatically reverts
        //msg.sender = address
        //payable(msg.sender) = payable address
        //payable(msg.sender).transfer(address(this).balance) ;

        //send -> returns boolean on hitting gas limit (success/fail)
        //doesnot revert automatically
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send Failed");

        //call -> lower level fn 
        //can be used to virtually call any function
        // returns two things -> bool(call success/fail) and bytes(data returned)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");

    }

    modifier onlyOwner(){
        //require(msg.sender == i_owner, "Sender is not the owner"); // executes first
        if(msg.sender != i_owner){
            revert NotOwner();
        }

        _; //rest of the function code executes -> will execute first if put above the require
        // nothing after the _; so the end
    }

    //Now what if someone sends eth to us without using the contract
    //Those senders wont get added in our funders list
    //To solve this, two ways - receive() or fallback()
    //these are special functions triggered and executes some code when eth is sent without using the contract
    // costs more gas though
    
    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }
    
}