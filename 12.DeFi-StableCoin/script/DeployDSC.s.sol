// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";

/**
 * @title DeployDSC
 * @author Tinotenda Joe
 * @dev Deploys the DecentralizedStableCoin, the DSCEngine and setup HelperConfig.
 * @return An instance of the DecentralizedStableCoin, DSCEngine and HelperConfig.
 */
contract DeployDSC is Script {
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;

    /**
     * @dev This function is the main runner for the Deployer.
     * It deploys instances of HelperConfig, DecentralizedStableCoin, and DSCEngine,
     * sets up the token addresses and price feed addresses,
     * and starts and stops a broadcast for deploying these contracts.
     * @return An instance of the DecentralizedStableCoin, DSCEngine, and HelperConfig.
     */

    function run() external returns (DecentralizedStableCoin, DSCEngine, HelperConfig) {
        // Deploy a new HelperConfig to inject mocks.

        HelperConfig helperConfig = new HelperConfig();

        // Get active network configurations from helperConfig.
        // This includes the price feed addresses for weth and wbtc,
        // the token addresses for weth and wbtc, and deployer key.

        (address wethUsdPriceFeed, address wbtcUsdPriceFeed, address weth, address wbtc, uint256 deployerKey) =
            helperConfig.activeNetworkConfig();

        // Set token addresses, including weth and wbtc.
        tokenAddresses = [weth, wbtc];

        // Set price feed addresses for weth and wbtc.
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        // Start a broadcast with a deployer key.
        // This will broadcast the deployment of the following contracts.
        vm.startBroadcast(deployerKey);

        // Deploy a new DecentralizedStableCoin contract.
        DecentralizedStableCoin dsc = new DecentralizedStableCoin();

        // Deploy a new DSCEngine contract and pass token addresses,
        // price feed addresses, and the address of DecentralizedStableCoin to it.
        DSCEngine dscEngine = new DSCEngine(
    tokenAddresses,
    priceFeedAddresses,
    address(dsc)
    );

        // Transfer the ownership of the DecentralizedStableCoin to the DSCEngine.
        dsc.transferOwnership(address(dscEngine));
        // Stop the broadcast after deploying the contracts.
        vm.stopBroadcast();

        // Return the instances of DecentralizedStableCoin, DSCEngine, and HelperConfig.
        return (dsc, dscEngine, helperConfig);
    }
}
