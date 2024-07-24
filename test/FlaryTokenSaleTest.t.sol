// SPDX-License-Identifier: MIT 

pragma solidity 0.8.22;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {Test, console} from "forge-std/Test.sol";
import {FlaryTokenSale} from "../src/FlaryTokenSale.sol";
import {DeployFlaryTokenSale} from "../script/DeployFlaryTokenSale.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FlaryTokenSaleTest is Test{
    FlaryTokenSale public flary;

    ERC20 usdt;
    uint256 tokenPriceInUsdt;

    address USER = makeAddr("user");

    function setUp() external {
        HelperConfig config = new HelperConfig();
        (, address usdtAddress, uint256 _tokenPriceInUsdt) = config.activeConfig();
        tokenPriceInUsdt = _tokenPriceInUsdt;
        usdt = ERC20(usdtAddress);

        DeployFlaryTokenSale deploy = new DeployFlaryTokenSale();
        flary = deploy.run();
    }

    function testBuyTokensWithNativeCorrectAmount() public {
        uint256 ethAmountToBuyTokens = 1 * 10 ** 18;

        flary.buyTokensNative{value: ethAmountToBuyTokens}();

        uint256 lowestPrice = 3300;
        uint256 highestPrice = 3600;

        uint256 lowestExpectedAmount = lowestPrice * (10 ** (usdt.decimals() + 18)) / tokenPriceInUsdt; 
        uint256 highestExpectedAmount = highestPrice * (10 ** (usdt.decimals() + 18)) / tokenPriceInUsdt; 


        assertLe(lowestExpectedAmount, flary.s_investemetByAddress(address(this)));
        assertGe(highestExpectedAmount, flary.s_investemetByAddress(address(this)));
    }

    function testBuyTokensWithUsdt() public {
        uint256 usdtAmount = 4 * (10 ** usdt.decimals());

        vm.prank(USER);
        flary.buyTokensUSDT(usdtAmount);

        uint256 expectedTokensAmount = usdtAmount * 10 ** 18 / tokenPriceInUsdt;

        assertEq(expectedTokensAmount, flary.s_investemetByAddress(address(this)));
    }

    function getReachUser() private view returns (address) {
        if (block.chainid == 1) {
            return 0xF977814e90dA44bFA03b6295A0616a897441aceC;
        }
        if (block.chainid == )
    }
}