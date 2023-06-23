# HelperConfig

The HelperConfig contract in the script is responsible for managing network configurations and providing the appropriate price feed address for the FundMe contract. Let's break down the script into smaller parts to understand it better.

## Import statements:

`import { MockV3Aggregator } from "../test/mock/MockV3Aggregator.sol";
import { Script } from "forge-std/Script.sol";`

These lines import the required contracts and libraries. MockV3Aggregator is a mock implementation of a price feed, and Script is a part of the Foundry framework.

## Contract definition and state variables:

```
contract HelperConfig is Script {
NetworkConfig public activeNetworkConfig;

       uint8 public constant DECIMALS = 8;
       int256 public constant INITIAL_PRICE = 2000e8;
```

Here, the contract `HelperConfig` is defined, inheriting from `Script`. The state variables `activeNetworkConfig`, `DECIMALS`, and `INITIAL_PRICE` are declared. `activeNetworkConfig` will store the current network configuration, while DECIMALS and INITIAL_PRICE are constants used for creating a mock price feed.

## NetworkConfig struct and event:

```
struct NetworkConfig {
address priceFeed;
}


event HelperConfig**CreatedMockPriceFeed(address priceFeed);
```

The `NetworkConfig` struct is used to store the price feed address. The `HelperConfig\*\*CreatedMockPriceFeed` event is emitted when a new mock price feed is created for Anvil

## Constructor:

```
  constructor() {
      if (block.chainid == 11155111) {
          activeNetworkConfig = getSepoliaEthConfig();
      } else {
          activeNetworkConfig = getOrCreateAnvilEthConfig();
      }
  }
```

The ` constructor` sets the `activeNetworkConfig` based on the current chain ID. If the chain ID is 11155111, it will use the `Sepolia network configuration`. Otherwise, it will use or create the Anvil network configuration.

## getSepoliaEthConfig function:

```
 function getSepoliaEthConfig() public pure returns (NetworkConfig memory sepoliaNetworkConfig) {
     sepoliaNetworkConfig = NetworkConfig({
         priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH / USD
     });
 }
```

This function returns the `Sepolia network configuration`, which has a hardcoded price feed address for the `ETH/USD` pair.

## getOrCreateAnvilEthConfig function:

```
function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
if (activeNetworkConfig.priceFeed != address(0)) {
return activeNetworkConfig;
}
vm.startBroadcast();
MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
vm.stopBroadcast();
emit HelperConfig\_\_CreatedMockPriceFeed(address(mockPriceFeed));

       anvilNetworkConfig = NetworkConfig({ priceFeed: address(mockPriceFeed) });

}
```

This function checks if the `activeNetworkConfig` has a valid price feed address. If it does, the function returns the current `activeNetworkConfig`. Otherwise, it creates a new MockV3Aggregator instance with the specified `DECIMALS` and `INITIAL_PRICE`, emits the `HelperConfig\_\_CreatedMockPriceFeed` event, and returns the new Anvil network configuration with the created mock price feed address.

The HelperConfig contract helps manage network configurations for the FundMe contract, making it easier to switch between different networks and price feeds.

# DeploFundME

The `DeployFundMe` contract in the script is a Foundry deployment script responsible for deploying the FundMe contract and initializing it with the appropriate price feed address. Let's break down the script into smaller parts to understand it better.

## Import statements:

```import { Script } from "forge-std/Script.sol";
   import { HelperConfig } from "./HelperConfig.s.sol";
   import { FundMe } from "../src/FundMe.sol";
```

These lines import the required contracts and libraries. Script is a part of the Foundry framework, HelperConfig is the helper contract for managing network configurations, and FundMe is the main contract to be deployed.

## Contract definition:

```
contract DeployFundMe is Script {

```

Here, the contract `DeployFundMe` is defined, inheriting from `Script`.

## run function:

```
function run() external returns (FundMe, HelperConfig) {
HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!
address priceFeed = helperConfig.activeNetworkConfig();

       vm.startBroadcast();
       FundMe fundMe = new FundMe(priceFeed);
       vm.stopBroadcast();
       return (fundMe, helperConfig);

}
```

The `run` function is the main deployment function. It performs the following steps:

- Creates a new instance of the `HelperConfig` contract.
- Retrieves the price feed address from the `activeNetworkConfig` of the `HelperConfig` contract.
- Starts broadcasting the deployment transaction using `vm.startBroadcast()`.
- Deploys the `FundMe` contract with the retrieved price feed address.
- Stops broadcasting using `vm.stopBroadcast()`.
- Returns the deployed `FundMe` contract and the `HelperConfig` contract.
- The `DeployFundMe` contract simplifies the deployment process of the `FundMe` contract by taking care of the network configuration and price feed initialization. When the `run` function is executed, it will deploy the `FundMe` contract with the appropriate price feed address based on the current network.

````

```

```
````
