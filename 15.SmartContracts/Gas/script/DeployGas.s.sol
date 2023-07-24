// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Gas} from "../src/gas.sol";

contract DeployGas is Script {
    function run() external returns (Gas) {
        vm.startBroadcast();
        Gas gas = new Gas();
        vm.stopBroadcast();

        return gas;
    }
}
