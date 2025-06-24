// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Variables {

    // string -> Just string
    // address -> wallet address
    // bool
    // uint (uint8, unit16, uint128, uint256)

    string message = "Hello, Solidity!";
    address owner = msg.sender; // sender of the message/contract 
    bool isReady = true;

    // Small Number
    uint8 MAX_SUPPLY = 10;
    uint256 WAIT_TIME = 1 days; // Huge number (in seconds)
}