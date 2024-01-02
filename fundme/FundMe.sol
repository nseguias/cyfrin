// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 minUsdAmount = 5e18;

    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minUsdAmount,
            "Didn't send enough ETH"
        );
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        uint256 amountToWithdraw = addressToAmountFunded[msg.sender];
        addressToAmountFunded[msg.sender] = 0;

        // There're 3 ways to send ETH to an address, the last one is the preferred one

        // transfer
        // payable(msg.sender).transfer(amountToWithdraw);

        // send
        // bool suceessfulSend = payable(msg.sender).send(amountToWithdraw);
        // require(suceessfulSend, "Failed to send funds");

        // call
        (bool successfulCall, ) = payable(msg.sender).call{
            value: amountToWithdraw
        }("");
        require(successfulCall, "Failed to call with value");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner");
        _;
    }
}
