// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ArbitrageReBot} from "../src/ArbitrageReBot.sol";

contract ArbitrageReBotTest is Test {
    ArbitrageReBot public arbitrageReBot;

    function setUp() public {
        arbitrageReBot = new ArbitrageReBot();
    }
}
