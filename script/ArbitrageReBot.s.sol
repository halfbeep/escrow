// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ArbitrageReBot} from "../src/ArbitrageReBot.sol";

contract ArbitrageReBotScript is Script {
    ArbitrageReBot public arbitrageReBot;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        arbitrageReBot = new ArbitrageReBot();

        vm.stopBroadcast();
    }
}
