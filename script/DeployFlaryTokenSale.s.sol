// SPDX-License-Identifier: MIT 

pragma solidity 0.8.22;

import {Script} from "forge-std/Script.sol";
import {FlaryTokenSale} from "../src/FlaryTokenSale.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFlaryTokenSale is Script {
    function run() external returns (FlaryTokenSale) {
        HelperConfig config = new HelperConfig();
        (address priceFeed, address usdtAddress, uint256 tokenPriceInUsdt) = config.activeConfig();
        

        vm.startBroadcast();
        FlaryTokenSale flary = new FlaryTokenSale(
            usdtAddress,
            priceFeed,
            tokenPriceInUsdt
        );
        vm.stopBroadcast();

        return flary;
    }
}