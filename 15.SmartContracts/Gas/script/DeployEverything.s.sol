// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Everything} from "../src/everything.sol";

contract DeployEverything is Script {
    function run() external returns (Everything) {
        vm.startBroadcast();
        Everything everything = new Everything();
        vm.stopBroadcast();

        return everything;
    }
}
