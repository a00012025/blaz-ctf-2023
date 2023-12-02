// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/ketai/Challenge.sol";
import "../src/ketai/Exploitor.sol";

contract ExploitScript is Script {
    function setUp() public {}

    function run() public {
        Challenge challenge = Challenge(
            address(0x73fCd7859037CEE8a903fb0338196D15c2b284Bb)
        );
        vm.startBroadcast();
        Exploitor exploitor = new Exploitor(challenge);
        exploitor.exploit(10);
        exploitor.exploit(10);
        exploitor.exploit(5);
        vm.stopBroadcast();
    }
}
