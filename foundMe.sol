// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {CCIPLocalSimulator} from "@chainlink/local@0.2.7-beta/src/ccip/CCIPLocalSimulator.sol";
import "GetterUSDT.sol";

// поддержать проект с учетом минимальной суммы исчесляемой в usd.
contract FundMe {
    using GetterUSDTPrice for uint256; 

    address immutable owner;
    uint constant MINIMUM_AMOUNT_SUPPORT = 50 * 1e6;
    mapping (address => uint256) public usersAmountFunded;

    constructor() {
        owner = msg.sender;
    }
    // 0,040_000_000_000_000_000
    // 0,040000000000

    function fund() public payable {
        require(msg.value.getConversionPrice() >= MINIMUM_AMOUNT_SUPPORT, "send more ETH");
        usersAmountFunded[msg.sender] += msg.value;
    }

    function getCurrecntPrice(uint weiAmount) external view returns(uint) {
        return weiAmount.getConversionPrice();
    }
    function getPrice() external view returns(uint) {
        return GetterUSDTPrice.getPrice();
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