// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import { MockV3Aggregator } from "../test/mock/MockV3Aggregator.sol";
import { Script } from "forge-std/Script.sol";

contract HelperConfig is Script {
	uint8 public constant DECIMALS = 8;
	int256 public constant INITIAL_PRICE = 200e8;
	struct NetworkConfig {
		address priceFeed;
	}
	NetworkConfig public activeNetworkConfig;
	event HelperConfig__CreatedMockPriceFeed(address priceFeed);

	constructor() {}

	function getSepoliaEthConfig()
		public
		pure
		returns (NetworkConfig memory sepoliaNetworkConfig)
	{
		sepoliaNetworkConfig = NetworkConfig({
			priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
		});
	}

	function getOrCreateAnvilEthConfig()
		public
		returns (NetworkConfig memory anvilNetworkConfig)
	{
		// Check to see if we set an active network config
		if (activeNetworkConfig.priceFeed != address(0)) {
			return activeNetworkConfig;
		}
		vm.startBroadcast();
		MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
			DECIMALS,
			INITIAL_PRICE
		);
		vm.stopBroadcast();
		emit HelperConfig__CreatedMockPriceFeed(address(mockPriceFeed));

		anvilNetworkConfig = NetworkConfig({
			priceFeed: address(mockPriceFeed)
		});
	}
}
