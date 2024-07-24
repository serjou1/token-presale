// SPDX-License-Identifier: MIT 

pragma solidity 0.8.22;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeConfig = getMainnetNetworkConfig();
        } else if (block.chainid == 56) {
            activeConfig = getBscNetworkConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed;
        address usdtAddress;
        uint256 tokenPriceInUsdt;
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            usdtAddress: 0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0,
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            tokenPriceInUsdt: 4 * 10 ** 6
        });
    }

    function getMainnetNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,
            usdtAddress: 0xdAC17F958D2ee523a2206206994597C13D831ec7,
            tokenPriceInUsdt: 4 * 10 ** 6
        });
    }

    function getBscNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE,
            usdtAddress: 0x55d398326f99059fF775485246999027B3197955,
            tokenPriceInUsdt: 4 * 10 ** 18
        });
    }
}