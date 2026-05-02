//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {NFTXNFT} from "../src/NFTXNFT.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {NFTX} from "../src/NFTX.sol";

contract NFTXScript is Script {
    HelperConfig public helperconfig;

    NFTX public nftx;

    function run() external returns (NFTX, NFTXNFT) {
        helperconfig = new HelperConfig();
        address pricefeed = helperconfig.ActiveNetworkConfig();
        vm.startBroadcast();
        nftx = new NFTX(pricefeed);
        vm.stopBroadcast();
        return (nftx, nftx.nftxnft());
    }
}
