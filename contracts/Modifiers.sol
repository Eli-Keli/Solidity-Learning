// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PausableToken {
    address public owner;
    bool public paused;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner() {
        // 1️⃣ Implement the modifier to allow only the owner to call the function ✅
        require(msg.sender == owner, "YOU ARE NOT THE OWNER");
        _;
    }

    // 2️⃣ Implement the modifier to check if the contract is not paused ✅
    modifier notPaused() {
        require(paused == false, "THE CONTRACT IS PAUSED");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    // 3️⃣ use the notPaused modifier in this function ✅
    function transfer(address to, uint amount) public notPaused {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
