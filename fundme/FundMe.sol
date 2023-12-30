// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 minUsdAmount = 5e18;

    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minUsdAmount,
            "Didn't send enough ETH"
        );
        addressToAmountFunded[msg.sender] += msg.value;
    }
}
