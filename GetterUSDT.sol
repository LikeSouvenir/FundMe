// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library GetterUSDTPrice {
    //0x694AA1769357215DE4FAC081bf1f309aDC325306
    //0x514910771AF9Ca656af840dff83E8264EcF986CA
    function getPrice() internal view returns(uint price) {
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int currentPrice,,,) = priceFeed.latestRoundData();
        // int currentPrice = 3289 * 1e8;
        price = uint(currentPrice) * 1e10;
    }

    function getConversionPrice(uint amountETH) internal view returns(uint) {
        return (getPrice() * amountETH) / 1e18;
    }
}