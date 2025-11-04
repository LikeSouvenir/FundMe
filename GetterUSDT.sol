// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library GetterUSDTPrice {

    function getPrice() internal view returns(int price) {
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0x514910771AF9Ca656af840dff83E8264EcF986CA);
        (, price,,,) = priceFeed.latestRoundData();
        price *= 1e10;
    }

    function getConversionPrice(uint amountETH) internal view returns(uint) {
        return uint(getPrice()) / amountETH / 1e18;
    }
}