// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Script } from "forge-std/Script.sol";
import { BasicNft } from "../src/BasicNFT.sol";

contract DeployBasicNft is Script {
	constructor() {}

	function run() external returns (BasicNft) {
		vm.startBroadcast();
		BasicNft basicNft = new BasicNft();
		vm.stopBroadcast();
		return basicNft;
	}
}
