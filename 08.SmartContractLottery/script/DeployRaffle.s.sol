// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { HelperConfig } from "./HelperConfig.s.sol";
import { Raffle } from "../src/Raffle.sol";
import { AddConsumer, CreateSubscription, FundSubscription } from "./Interactions.s.sol";

contract DeployRaffle is Script {
	function run() external returns (Raffle, HelperConfig) {
		// Create an instance of the HelperConfig contract
		HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!

		// Create an instance of the AddConsumer contract
		AddConsumer addConsumer = new AddConsumer();

		// Get the configuration parameters from the HelperConfig contract
		(
			uint64 subscriptionId,
			bytes32 gasLane,
			uint256 automationUpdateInterval,
			uint256 raffleEntranceFee,
			uint32 callbackGasLimit,
			address vrfCoordinatorV2,
			address link,
			uint256 deployerKey
		) = helperConfig.activeNetworkConfig();

		// If no subscription ID is set
		if (subscriptionId == 0) {
			// Create an instance of the CreateSubscription contract
			CreateSubscription createSubscription = new CreateSubscription();

			// Create a new subscription and get the subscription ID
			subscriptionId = createSubscription.createSubscription(
				vrfCoordinatorV2,
				deployerKey
			);

			// Create an instance of the FundSubscription contract
			FundSubscription fundSubscription = new FundSubscription();

			// Fund the subscription with LINK tokens
			fundSubscription.fundSubscription(
				vrfCoordinatorV2,
				subscriptionId,
				link,
				deployerKey
			);
		}

		// Start the broadcast
		vm.startBroadcast(deployerKey);

		// Create an instance of the Raffle contract with the given parameters
		Raffle raffle = new Raffle(
			subscriptionId,
			gasLane,
			automationUpdateInterval,
			raffleEntranceFee,
			callbackGasLimit,
			vrfCoordinatorV2
		);

		// Stop the broadcast
		vm.stopBroadcast();

		// Add the raffle contract as a consumer to the VRF Coordinator
		addConsumer.addConsumer(
			address(raffle),
			vrfCoordinatorV2,
			subscriptionId,
			deployerKey
		);

		// Return the raffle contract and the HelperConfig contract
		return (raffle, helperConfig);
	}
}
