//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DotBlockers} from "../src/DotBlockers.sol";

contract DotBlockersScript is Script {
    DotBlockers public dbt;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        dbt = new DotBlockers();

        vm.stopBroadcast();
    }
}