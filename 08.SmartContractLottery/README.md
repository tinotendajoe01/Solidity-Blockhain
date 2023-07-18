<!-- @format -->

# Foundry Smart Contract Lottery

This is a section of the Cyfrin Foundry Solidity Course.

_[⭐️ (3:04:09) | Lesson 9: Foundry Smart Contract Lottery](https://www.youtube.com/watch?v=sas02qSFZ74&t=11049s)_

- [Foundry Smart Contract Lottery](#foundry-smart-contract-lottery)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
    - [Optional Gitpod](#optional-gitpod)
- [Usage](#usage)
  - [Start a local node](#start-a-local-node)
  - [Library](#library)
  - [Deploy](#deploy)
  - [Deploy - Other Network](#deploy---other-network)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
- [Deployment to a testnet or mainnet](#deployment-to-a-testnet-or-mainnet)
  - [Scripts](#scripts)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)
- [Thank you!](#thank-you)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Quickstart

```
git clone https://github.com/Cyfrin/foundry-smart-contract-lottery-f23
cd foundry-smart-contract-lottery-f23
forge build
```

### Optional Gitpod

If you can't or don't want to run and install locally, you can work with this repo in Gitpod. If you do this, you can skip the `clone this repo` part.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#github.com/Cyfrin/foundry-smart-contract-lottery-f23)

# Usage

## Start a local node

```
make anvil
```

## Library

If you're having a hard time installing the chainlink library, you can optionally run this command.

```
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```

## Deploy

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```
make deploy
```

## Deploy - Other Network

[See below](#deployment-to-a-testnet-or-mainnet)

## Testing

We talk about 4 test tiers in the video.

1. Unit
2. Integration
3. Forked
4. Staging

This repo we cover #1 and #3.

```
forge test
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
  - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.

2. Deploy

```
make deploy ARGS="--network sepolia"
```

This will setup a ChainlinkVRF Subscription for you. If you already have one, update it in the `scripts/HelperConfig.s.sol` file. It will also automatically add your contract as a consumer.

3. Register a Chainlink Automation Upkeep

[You can follow the documentation if you get lost.](https://docs.chain.link/chainlink-automation/compatible-contracts)

Go to [automation.chain.link](https://automation.chain.link/new) and register a new upkeep. Choose `Custom logic` as your trigger mechanism for automation. Your UI will look something like this once completed:

![Automation](./img/automation.png)

## Scripts

After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:

```
cast send <RAFFLE_CONTRACT_ADDRESS> "enterRaffle()" --value 0.1ether --private-key <PRIVATE_KEY> --rpc-url $SEPOLIA_RPC_URL
```

or, to create a ChainlinkVRF Subscription:

```
make createSubscription ARGS="--network sepolia"
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`

# Formatting

To run code formatting:

```
forge fmt
```

# Notes on Contracts

# Raffle.sol

The given Raffle contract uses Chainlink VRFv2 to generate a random winner for the raffle. Chainlink VRF (Verifiable Random Function) is a cryptographically secure source of randomness for smart contracts chain.link. The contract also uses Chainlink Keepers to automatically draw a winner once a certain condition is met, such as a set number of players or a time interval

To understand the Raffle contract better, let's break it down step by step:

## Import dependencies:

The contract imports the necessary dependencies for VRF and Keepers, including `VRFCoordinatorV2Interface`, `VRFConsumerBaseV2`, and `AutomationCompatibleInterface`

## Contract definition and inheritance:

The Raffle contract inherits from `VRFConsumerBaseV2` and `AutomationCompatibleInterface.`

## State variables:

The contract defines state variables for the raffle, including the VRF variables, raffle variables, and the raffle state.

## Constructor:

The constructor initializes the state variables, including the VRF and raffle parameters.

## Raffle entry:

The enterRaffle function allows users to enter the raffle by sending the required entrance fee.

## Check Upkeep:

The checkUpkeep function is used by Chainlink Keepers to determine if the raffle needs to be drawn. It checks if the time interval has passed, the raffle is open, the contract has a balance, and there are players in the raffle.

## Perform Upkeep:

The performUpkeep function is called by Chainlink Keepers when checkUpkeep returns true. It requests random words from the VRF to pick a winner.

# fulfillRandomWords()

the function is a crucial part of the Raffle contract, as it is responsible for picking the raffle winner and transferring the prize to the winner. This function is called by the Chainlink VRF node after it generates a random value in response to the request made by the `performUpkeep ` function. Let's dive into the function step by step:

## Function definition:

The fulfillRandomWords function takes two arguments: `requestId`, which is the identifier for the VRF request, and randomWords, an array containing the random value generated by the Chainlink VRF node.

## Determine the winner:

The function calculates the index of the winner by taking the modulo of the first random value in the randomWords array with the number of players. This ensures that the winner index is within the range of the players.

## Assign the winner:

The function assigns the winner by accessing the player at the calculated index in the s_players array.

## Reset the raffle:

The function resets the raffle by clearing the s_players array, setting the raffle state to OPEN, and updating the s_lastTimeStamp.

## Transfer the prize:

The function transfers the entire balance of the contract to the winner using the call function. If the transfer is unsuccessful, it reverts the transaction with a custom error.

## Emit the event:

Finally, the function emits the WinnerPicked event with the winner's address.

# Events in solidity

Solidity events are an important feature in smart contracts that enable you to emit information to external systems and applications by storing data in transaction logs. These logs are stored on the blockchain and are accessible through the contract's address as long as the contract exists on the blockchain

Events can be used for various purposes, such as notifying external systems of specific occurrences within your smart contract, testing smart contracts for specific variables, and updating frontends automatically.They can be indexed, which means you can search for them, making it easier for external systems to interact with your smart contract

To declare an event in Solidity, you can use the following syntax:

```
event Deposit(address indexed _from, bytes32 indexed _id, uint _value);
```

To emit an event, you can use the emit keyword:

```
emit Deposit(msg.sender, _id, msg.value);
```

Here is an example of a simple smart contract that uses an event:

```pragma solidity ^0.5.0;

contract Test {
    event Deposit(address indexed _from, bytes32 indexed _id, uint _value);

    function deposit(bytes32 _id) public payable {
        emit Deposit(msg.sender, _id, msg.value);
    }
}
```

In the given example, we have a simple smart contract called `Test`. The contract has an `event` called `Deposit`, and a function called `deposit`. Let's break down each part of the code:

`event Deposit(address indexed _from, bytes32 indexed _id, uint _value);`: This line declares an `event` called `Deposit` with three parameters:` _from,` \_id,` and` \_value`. The i`ndexed`keyword is used for`\_from` and` \_id`, which means that these values can be searched when filtering events. Events are used to `emit` information to external applications and store data in transaction logs on the blockchain.

`function deposit(bytes32 _id) public payable {`: The `deposit` function is declared as `public` and `payable`, which means that it can be called by any external account, and it can receive Ether (in the form of `msg.value`). The function takes one argument, `_id`, which is a `bytes32` value.

`emit Deposit(msg.sender, _id, msg.value);`: Within the deposit function, the `Deposit` event is emitted using the emit keyword. The event is emitted with three arguments: `msg.sender`, `_id`, and `msg.value`. `msg.sender` represents the address of the account that called the function, `_id` is the input parameter of the function, and `msg.value` is the amount of Ether sent along with the function call.

When the `deposi`t function is called, it emits the `Deposit` event with the sender's address, the input \_id, and the amount of Ether sent. External applications can then listen to this event and take appropriate actions based on the emitted data. The event data is stored in transaction logs on the blockchain, and can be accessed as long as the contract exists on the blockchain

To interact with events in a client-side application, you can use a JavaScript library like Web3.js:

```
var abi = /* abi as generated using the compiler */;
var ClientReceipt = web3.eth.contract(abi);
var clientReceiptContract = ClientReceipt.at("0x1234...ab67" /* address */);
var event = clientReceiptContract.Deposit(function(error, result) {
    if (!error) console.log(result);
});
```

https://blog.chain.link/events-and-logging-in-solidity/

# Enumerators

Enums (short for "enumerations") in Solidity are a way to create user-defined data types that restrict a variable to have one of a few predefined values. They are useful for making the contract more readable and reducing bugs in the code by limiting the possible values a variable can take

```
enum <enumerator_name> {
    element1, element2, ..., elementN
}
```

Each element in the enum is assigned an integer value starting from 0. You can explicitly convert enums to and from integer types, but implicit conversion is not allowed. The explicit conversions check the value ranges at runtime, and a failure causes an exception

For example, consider a simple enum for representing week days:

```
enum WeekDays {
    Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}
```

In the Raffle contract, an enum called `RaffleState` is used to represent the state of the raffle:

```
enum RaffleState { OPEN, CLOSED }
```

This enum has two possible values: `OPEN `and` CLOSED`. By using an enum, the contract ensures that the raffle state can only take one of these two values, making the code more readable and less error-prone.

To use an enum in a contract, you can declare a state variable of the enum type, like this:

```
RaffleState public s_raffleState;
```

In the Raffle contract, the `s_raffleState` variable is used to store the current state of the raffle. The contract also uses a modifier called `onlyOpenRaffle` to restrict certain functions to be called only when the raffle is in the OPEN state:

```
modifier onlyOpenRaffle() {
    require(s_raffleState == RaffleState.OPEN, "Raffle is not open");
    _;
}
```

Here, the require statement checks if s_raffleState is equal to RaffleState.OPEN. If the condition is not met, an error message is thrown, and the function execution is reverted. This demonstrates how enums can help enforce specific conditions in a contract and improve code readability.
