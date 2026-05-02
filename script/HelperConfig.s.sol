//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address pricefeed;
    }

    NetworkConfig public ActiveNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia
            ActiveNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            // Mainnet
            ActiveNetworkConfig = getMainnetConfig();
        } else {
            ActiveNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            pricefeed: address(0x694AA1769357215DE4FAC081bf1f309aDC325306) // Sepolia ETH/USD price feed address
        });
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            pricefeed: address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419) // Mainnet ETH/USD price feed address
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (ActiveNetworkConfig.pricefeed != address(0)) {
            return ActiveNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        return NetworkConfig({
            pricefeed: address(mockPriceFeed)
        });
    }
}
