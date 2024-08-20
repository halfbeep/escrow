// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SecureTransfer} from "../src/SecureTransfer.sol";

contract SecureTransferScript is Script {
    SecureTransfer public secureTransfer;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        secureTransfer = new SecureTransfer();

        vm.stopBroadcast();
    }
}
