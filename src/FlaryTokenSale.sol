// SPDX-License-Identifier: MIT 

pragma solidity 0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FlaryTokenSale is Ownable, Pausable, ReentrancyGuard {
    using SafeERC20 for ERC20;

    ERC20 public s_usdt;

    AggregatorV3Interface public s_native_usd_priceFeed;
    uint256 public i_tokensPriceInUsdt;

    uint256 public s_tokenSold;
    mapping(address => uint256) public s_investemetByAddress;
    address[] public buyers;

    constructor(
        address _usdt,
        address _priceFeed,
        uint256 _tokensPriceInUsdt
    ) Ownable(msg.sender) {
        s_usdt = ERC20(_usdt);
        s_native_usd_priceFeed = AggregatorV3Interface(_priceFeed);
        i_tokensPriceInUsdt = _tokensPriceInUsdt;
    }

    function buyTokensNative() external payable whenNotPaused {
        buyers.push(msg.sender);

        (, int256 nativePrice, , , ) = s_native_usd_priceFeed.latestRoundData();

        uint8 feedDecimals = s_native_usd_priceFeed.decimals();
        uint8 usdtDecimals = s_usdt.decimals();

        // assuming token's decimals 18
        uint256 tokensAmount;
        if (feedDecimals > usdtDecimals) {
            tokensAmount = msg.value * uint256(nativePrice) / (i_tokensPriceInUsdt * 10 ** (feedDecimals - usdtDecimals));
        } else {
            tokensAmount = msg.value * uint256(nativePrice) * 10 ** (usdtDecimals - feedDecimals) / i_tokensPriceInUsdt;
        }
        
        s_investemetByAddress[msg.sender] += tokensAmount;
        s_tokenSold += tokensAmount;
    }

    function buyTokensUSDT(uint256 amount) external whenNotPaused {
        s_usdt.safeTransferFrom(msg.sender, address(this), amount);

        uint256 tokensAmount = amount * 10 ** 18 / i_tokensPriceInUsdt;

        s_investemetByAddress[msg.sender] += tokensAmount;
        s_tokenSold += tokensAmount;
    }

    function pause() external whenNotPaused onlyOwner {
        _pause();
    }

    function unpause() external whenPaused onlyOwner {
        _unpause();
    }

    function withdrawUSDT(
        uint256 _amount
    ) external onlyOwner {
        s_usdt.approve(address(this), _amount);
        s_usdt.safeTransferFrom(address(this), owner(), _amount);
    }

    function withdrawNative(uint256 _amount) external onlyOwner {
        (bool hs, ) = payable(owner()).call{value: _amount}("");
        require(hs, "EnergiWanBridge:: Failed to withdraw native coins");
    }
}