// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Script } from "forge-std/Script.sol";
import { FundProject } from "../src/FundProject.sol";

contract DeployFundProject is Script {
	function run() external returns (FundProject) {
		vm.startBroadcast();
		FundProject fundProject = new FundProject();
		vm.stopBroadcast();
		return fundProject;
	}
}
