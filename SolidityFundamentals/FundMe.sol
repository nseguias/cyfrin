// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
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
        // the code below is not gas efficient
        // require(msg.sender == i_owner, "Must be owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
