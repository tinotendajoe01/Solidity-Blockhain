// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { SimpleStorage } from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
	function run() external returns (SimpleStorage) {
		vm.startBroadcast();
		SimpleStorage simpleStorage = new SimpleStorage();
		vm.stopBroadcast();
		return simpleStorage;
	}
}
