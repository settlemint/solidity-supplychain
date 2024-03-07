// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter; // Instance of the Counter contract

    function setUp() public {
        string memory key = "DEPLOYED_ADDRESS";
        counter = Counter(vm.envAddress(key));
    }

    function run() public {
        vm.startBroadcast();

        counter.setNumber(5); // Set the initial number

        uint256 initialCount = counter.number(); // Read the current value of the counter
        console.log("Current Counter Value:", initialCount); // Log the current counter value

        counter.increment(); // Call the increment function of the Counter contract

        uint256 currentCount = counter.number(); // Read the current value of the counter
        console.log("Current Counter Value:", currentCount); // Log the current counter value
    }
}