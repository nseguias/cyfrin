// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract FundMe {
    function fund() public payable {
        require(msg.value >= 1e17, "Didn't send enough ETH");
    }
}
