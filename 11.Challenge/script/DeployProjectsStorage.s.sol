// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Script } from "forge-std/Script.sol";
import { ProjectsStorage } from "../src/ProjectsStorage.sol";

contract DeployProjectsStorage is Script {
	function run() external returns (ProjectsStorage) {
		vm.startBroadcast();
		ProjectsStorage projectsStorage = new ProjectsStorage();
		vm.stopBroadcast();
		return projectsStorage;
	}
}
