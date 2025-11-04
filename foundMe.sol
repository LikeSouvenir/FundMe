// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {CCIPLocalSimulator} from "@chainlink/local@0.2.7-beta/src/ccip/CCIPLocalSimulator.sol";
import "GetterUSDT.sol";

// поддержать проект с учетом минимальной суммы исчесляемой в usd.
contract FundMe {
    using GetterUSDTPrice for uint256; 

    address immutable owner;
    uint immutable MINIMUM_AMOUNT_SUPPORT;
    mapping (address => uint256) public usersAmountFunded;

    constructor(uint minAmountUSD) {
        owner = msg.sender;
        MINIMUM_AMOUNT_SUPPORT = minAmountUSD * 1e18;
    }
    // 0,040_000_000_000_000_000
    // 0,040_000_000_000

    function fund() public payable {
        require(msg.value.getConversionPrice() >= MINIMUM_AMOUNT_SUPPORT, "send more ETH");
        usersAmountFunded[msg.sender] += msg.value;
    }

    function getCurrecntPrice(uint weiAmount) external view returns(uint) {
        return weiAmount.getConversionPrice();
    }

    function withdraw() external payable {
        require(msg.sender == owner, "only owner");
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "withdraw faild");
    }
    receive() external payable { 
        fund();
    }
    fallback() external payable {
        fund();
     }
}