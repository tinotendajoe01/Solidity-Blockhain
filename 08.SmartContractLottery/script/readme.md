# Sript Contracts

This folder contains raffle.sol deploy scripts and config contracts for managing subscriptions and interacting with the VRF (Verifiable Random Function) coordinator.

## DeployRaffle.s.sol

This contract is responsible for deploying the Raffle contract and setting up the necessary configurations. It utilizes the `HelperConfig` contract to fetch the active network configuration and retrieve the VRF coordinator and deployer key. The `run()` function serves as the entry point for executing the contract's functionality and deploys the Raffle contract.

## HelperConfig.s.sol

The `HelperConfig` contract provides a configuration interface to retrieve various network-specific parameters, such as the VRF coordinator address, deployer key, link token address, and subscription ID. These parameters are used by other contracts to interact with the VRF coordinator and manage subscriptions.

## CreateSubscription

This contract allows users to create a subscription using the provided VRF coordinator and deployer key. It also provides a convenience function `createSubscriptionUsingConfig()` that retrieves the necessary parameters from the `HelperConfig` contract. The `run()` function serves as the entry point for executing the contract's functionality.

## AddConsumer

The `AddConsumer` contract is responsible for adding a consumer contract to the VRF coordinator. It provides two functions: `addConsumer()` and `addConsumerUsingConfig()`. The former allows users to add a consumer contract by providing the necessary parameters, while the latter retrieves the parameters from the `HelperConfig` contract. The `run()` function serves as the entry point for executing the contract's functionality and retrieves the most recently deployed consumer contract.

## FundSubscription

This contract handles the funding of a subscription. It provides two functions: `fundSubscription()` and `fundSubscriptionUsingConfig()`. The former allows users to fund a subscription by providing the necessary parameters, while the latter retrieves the parameters from the `HelperConfig` contract. The contract includes a constant `FUND_AMOUNT` that specifies the amount to be funded. The `run()` function serves as the entry point for executing the contract's functionality.
