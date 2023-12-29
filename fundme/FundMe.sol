// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

contract FundMe {
    function fund() public payable {
        require(msg.value >= 1e17, "Didn't send enough ETH");
    }

    function getPrice() public view returns (uint256) {
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        // Price of ETH in USD. Needs to adjust decimals from 6 to 18.
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price) * 1e10;
    }

    function getConversionRate() public {}
}
