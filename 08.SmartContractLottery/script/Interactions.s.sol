// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";
import { HelperConfig } from "./HelperConfig.s.sol";
import { Raffle } from "../src/Raffle.sol";
import { DevOpsTools } from "foundry-devops/src/DevOpsTools.sol";
import { VRFCoordinatorV2Mock } from "../test/mocks/VRFCoordinatorV2Mock.sol";
import { LinkToken } from "../test/mocks/LinkToken.sol";

// Contract for creating a subscription
contract CreateSubscription is Script {
	// Create a subscription using the configuration from HelperConfig
	function createSubscriptionUsingConfig() public returns (uint64) {
		HelperConfig helperConfig = new HelperConfig();
		(
			,
			,
			,
			,
			,
			address vrfCoordinatorV2,
			,
			uint256 deployerKey
		) = helperConfig.activeNetworkConfig();
		return createSubscription(vrfCoordinatorV2, deployerKey);
	}

	// Create a subscription with the provided VRF coordinator and deployer key
	function createSubscription(
		address vrfCoordinatorV2,
		uint256 deployerKey
	) public returns (uint64) {
		console.log("Creating subscription on chainId: ", block.chainid);
		vm.startBroadcast(deployerKey);
		uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2)
			.createSubscription();
		vm.stopBroadcast();
		console.log("Your subscription Id is: ", subId);
		console.log("Please update the subscriptionId in HelperConfig.s.sol");
		return subId;
	}

	// Entry point for executing the contract's functionality
	function run() external returns (uint64) {
		return createSubscriptionUsingConfig();
	}
}

// Contract for adding a consumer to the VRF coordinator
contract AddConsumer is Script {
	// Add a consumer contract to the VRF coordinator
	function addConsumer(
		address contractToAddToVrf,
		address vrfCoordinator,
		uint64 subId,
		uint256 deployerKey
	) public {
		console.log("Adding consumer contract: ", contractToAddToVrf);
		console.log("Using vrfCoordinator: ", vrfCoordinator);
		console.log("On ChainID: ", block.chainid);
		vm.startBroadcast(deployerKey);
		VRFCoordinatorV2Mock(vrfCoordinator).addConsumer(
			subId,
			contractToAddToVrf
		);
		vm.stopBroadcast();
	}

	// Add a consumer using the configuration from HelperConfig
	function addConsumerUsingConfig(address mostRecentlyDeployed) public {
		HelperConfig helperConfig = new HelperConfig();
		(
			uint64 subId,
			,
			,
			,
			,
			address vrfCoordinatorV2,
			,
			uint256 deployerKey
		) = helperConfig.activeNetworkConfig();
		addConsumer(mostRecentlyDeployed, vrfCoordinatorV2, subId, deployerKey);
	}

	// Entry point for executing the contract's functionality
	function run() external {
		address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
			"Raffle",
			block.chainid
		);
		addConsumerUsingConfig(mostRecentlyDeployed);
	}
}

// Contract for funding a subscription
contract FundSubscription is Script {
	uint96 public constant FUND_AMOUNT = 3 ether;

	// Fund a subscription using the configuration from HelperConfig
	function fundSubscriptionUsingConfig() public {
		HelperConfig helperConfig = new HelperConfig();
		(
			uint64 subId,
			,
			,
			,
			,
			address vrfCoordinatorV2,
			address link,
			uint256 deployerKey
		) = helperConfig.activeNetworkConfig();
		fundSubscription(vrfCoordinatorV2, subId, link, deployerKey);
	}

	// Fund a subscription with the provided VRF coordinator, subscription ID, link token, and deployer key
	function fundSubscription(
		address vrfCoordinatorV2,
		uint64 subId,
		address link,
		uint256 deployerKey
	) public {
		console.log("Funding subscription: ", subId);
		console.log("Using vrfCoordinator: ", vrfCoordinatorV2);
		console.log("On ChainID: ", block.chainid);
		if (block.chainid == 31337) {
			vm.startBroadcast(deployerKey);
			VRFCoordinatorV2Mock(vrfCoordinatorV2).fundSubscription(
				subId,
				FUND_AMOUNT
			);
			vm.stopBroadcast();
		} else {
			console.log(LinkToken(link).balanceOf(msg.sender));
			console.log(msg.sender);
			console.log(LinkToken(link).balanceOf(address(this)));
			console.log(address(this));
			vm.startBroadcast(deployerKey);
			LinkToken(link).transferAndCall(
				vrfCoordinatorV2,
				FUND_AMOUNT,
				abi.encode(subId)
			);
			vm.stopBroadcast();
		}
	}

	function run() external {
		fundSubscriptionUsingConfig();
	}
}
