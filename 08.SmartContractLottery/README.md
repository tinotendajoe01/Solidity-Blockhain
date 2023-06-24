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
