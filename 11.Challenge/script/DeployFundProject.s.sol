// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Script } from "forge-std/Script.sol";
import { FundProject } from "../src/FundProject.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployFundProject is Script {
	function run() external returns (FundProject, HelperConfig) {
		HelperConfig helperConfig = new HelperConfig();
		address priceFeed = helperConfig.activeNetworkConfig();
		vm.startBroadcast();
		FundProject fundProject = new FundProject(priceFeed);
		vm.stopBroadcast();
		return (fundProject, helperConfig);
	}
}
