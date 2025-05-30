//SPDX-License-Identifier: MIT

//1. Deploy mocks when we are on a local anvil chain
//2. Keep track of contract addresses across different chains
//Sepolia ETH/USD
//Ethereum Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local anvil chain, we will deploy mocks
    //otherwise grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8; // 2000 USD with 8 decimals

    struct NetworkConfig {
        address ethUsdPriceFeed; // ETH/USD Price Feed Address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        //Sepolia ETH/USD Price Feed Address
        NetworkConfig memory sepoliaConfig =
            NetworkConfig({ethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        //Sepolia ETH/USD Price Feed Address
        NetworkConfig memory mainnetConfig =
            NetworkConfig({ethUsdPriceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.ethUsdPriceFeed != address(0)) {
            return activeNetworkConfig; // Return existing config if already set
        }

        //Anvil ETH/USD Price Feed Address
        vm.startBroadcast();
        // Deploy a mock aggregator for local testing
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER); // 2000 USD with 8 decimals
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({ethUsdPriceFeed: address(mockV3Aggregator)});

        return anvilConfig;
    }
}
