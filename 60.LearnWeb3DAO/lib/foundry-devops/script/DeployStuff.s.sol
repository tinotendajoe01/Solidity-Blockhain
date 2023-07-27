// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";

contract Stuff {
    function getSeven() public pure returns (uint256) {
        return 7;
    }
}

contract DeployStuff is Script {
    function run() external {
        vm.startBroadcast();
        new Stuff();
        vm.stopBroadcast();
    }
}
