//SPDX-License-Identifier: Unlicense

//Fund
//Withdraw

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded %s with %s wei", mostRecentlyDeployedAddress, SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployedAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployedAddress);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployedAddress);
    }
}
