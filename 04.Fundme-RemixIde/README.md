# FundMe and PriceConverter

This repository contains two Solidity smart contracts: `FundMe` and `PriceConverter`.

## Table of Contents

- [Contracts](#Contracts)
  - [FundMe](#FundMe)
  - [PriceConverter](#PriceConverter)
- [Usage](#Usage)
- [Author](#Author)
- [License](#License)
- [Disclaimer](#Disclaimer)

## Contracts

### FundMe

`FundMe` is a crowdfunding contract. Funds can be donated in the form of ETH. It uses the PriceConverter contract to convert the donated ETH amount into USD. This conversion ensures that at least a specific minimum USD amount is donated with each contribution. The contract owner has the ability to withdraw funds at any time. There is also a mechanism in place for the return of donations if the funding goal is not met by a certain deadline.

### PriceConverter

`PriceConverter` uses Chainlink's AggregatorV3Interface to access up-to-date ETH to USD conversion rates. It provides functionality to fetch the ETH to USD price and convert a certain ETH amount into its USD equivalent.

## Usage

To utilize these contracts, you need to:

1. Compile the contracts with Solidity compiler (solc). If you are using a platform like Remix, this is done for you automatically.
2. Deploy the contracts using the Ethereum network of your choice. You can use a service like Metamask or Truffle for this.
3. Interact with the contracts using Web3 in a web browser or using Hardhat or Truffle scripts.

For more advanced usage, you'll typically want to integrate these contracts into a web interface using a library like Web3.js or Ethers.js.

## License

The contracts in this repository are licensed under the MIT license.

## Author

**Tinotenda Joe**

- [Profile](https://github.com/tinotendajoe01)
- [Email](mailto:tinotendajoe01@gmail.com)
- [Twitter](https://twitter.com/tinotendajoe01)

## Disclaimer

Please note that these contracts are for educational purposes and should not be used in production without further modifications. Always audit and test your contracts before using them in a live environment.

### Fallback

In Solidity, "fallback" and "receive" are special functions that are used to handle incoming ether and data that is sent to a contract.

The fallback function is a special function that is executed when a contract receives a transaction that does not match any of its defined functions. This can happen when a user sends ether to the contract without specifying a function to call. The fallback function is optional and has the following signature:

```
function () external payable {
    // code to handle incoming ether without data
}
```

The fallback function is marked as "payable" to allow it to receive ether. If the fallback function is not defined and a transaction is sent to the contract without specifying a function to call, the transaction will fail and the ether will be returned to the sender.

The receive function is a new function that was introduced in Solidity version 0.6.0. It is similar to the fallback function, but it is specifically designed to handle incoming data without any accompanying ether. The receive function has the following signature:

```
function () external payable {
    // code to handle incoming ether without data
}
```

The receive function is also marked as "payable" to allow it to receive ether in case it is sent with data. The receive function is called automatically when a contract receives a transaction with data but no function specifier. If the receive function is not defined and a transaction is sent to the contract with data but no function specifier, the transaction will fail.

In summary, the fallback function is used to handle incoming ether and data when no other function matches the transaction, while the receive function is used to handle incoming data without any accompanying ether.

### Decentralized oracles - Chainlink information

Decentralized oracles are a critical component in the development of smart contracts and blockchain applications, as they provide a secure and reliable bridge between off-chain data sources and on-chain smart contracts. Chainlink is a prominent example of a decentralized oracle network that connects real-world data to blockchain-based smart contracts gemini.com.

Smart contracts cannot access external data feeds on their own; they require an intermediary layer for facilitation, which is the role of oracles. However, relying on a single centralized oracle can introduce a single point of failure, compromising the security and reliability of smart contracts blockonomi.com. Decentralized oracles, like Chainlink, eliminate this issue by using a network of independent nodes that provide data inputs and outputs to smart contracts medium.com.

Chainlink uses a decentralized network of nodes to provide tamper-proof inputs and outputs for complex smart contracts on any blockchain, ensuring the same security guarantees as the smart contracts themselves. By allowing multiple nodes to evaluate the same data before it triggers a smart contract, Chainlink eliminates single points of failure and maintains a high level of security, reliability, and trustworthiness medium.com.

Chainlink's decentralized oracle network is designed to be compatible with various blockchain platforms, such as Ethereum, Bitcoin, and Hyperledger. Its modular architecture allows for upgradability, and it incentivizes good behavior among nodes with a reputation system and penalties for bad behavior medium.com.

By providing a secure and reliable connection between off-chain data sources and on-chain smart contracts, Chainlink enables a wide range of use cases. For example, Arbol uses Chainlink for weather data to create weather risk products, and Theta Network leverages Chainlink for viewership data to fight ad fraud for online content https://chain.link/education/blockchain-oracles

In summary, decentralized oracles like Chainlink play a crucial role in the development of smart contracts and blockchain applications. They provide a secure and reliable bridge between off-chain data sources and on-chain smart contracts, enabling more sophisticated and flexible applications on the blockchain gemini.com.

## FUNDME

This smart contract is called "FundMe" and it is like a digital piggy bank that allows people to send money (in the form of cryptocurrency called Ether) to a specific goal. Here's what it does in simple terms:

It keeps track of who sent money and how much they sent.
It has a minimum amount that people need to send (in USD) to participate.
It has a maximum goal that the piggy bank can hold.
It has a deadline, after which people cannot send more money.
When the maximum goal is reached, the money is sent to a specified address.
The owner of the smart contract (the person who created it) can set the maximum goal, deadline, and destination address for the funds.
The owner can also withdraw the funds if needed.
People who sent money can also take back their money if the maximum goal hasn't been reached.

Here's a brief explanation of some important parts of the code:

-The `fund()` function allows people to send money to the smart contract. It checks if the amount sent is enough (minimum USD) and if the maximum goal and deadline haven't been reached. If everything is fine, it updates the records and sends the money to the destination address when the goal is reached. It also triggers a "NewDonation" event to let others know about the donation.

-The `setMaxGoal()` and `setDeadline()` functions allow the owner to set the maximum goal and deadline for the funding campaign.

`The `withdraw()` function allows the owner to take out the money from the smart contract. It resets the records and transfers the money to the owner's address.

-The `setFundsDestination()` function allows the owner to set the destination address for the funds.

-The `getContractBalance()` function shows how much money is in the smart contract.

The `withdrawFunds()` function allows people who sent money to take back their money if the maximum goal hasn't been reached.

The `getDonations()` function shows the list of all donations made to the smart contract.

The `fallback()` and `receive()` functions allow the smart contract to receive money without any data and automatically call the fund() function to process the received Ether.

### FALLBACK() AND RECEIVE()

The fallback() and receive() functions in a Solidity smart contract are special functions that handle incoming Ether transactions that do not include any data or do not match any other function in the contract. These functions help make a smart contract more robust and flexible when interacting with other contracts or users.

When someone sends Ether to a smart contract, the Ethereum network creates a transaction. This transaction can include ``data`, such as the name of a function to call within the contract, and its arguments. If the transaction does not include any data, or the data does not match any function in the contract, then the fallback() or receive() functions are called.

Here's how it works:

If the transaction includes `data (i.e., msg.data is not empty)`, the Ethereum network tries to find a matching function in the smart contract and execute it. If no matching function is found, the fallback() function is called, if it is defined.
If the transaction does not include any data (i.e., msg.data is empty), the network checks if the receive() function is defined in the smart contract. If it is, the receive() function is called. If it is not defined, the fallback() function is called, if it is defined.
In the FundMe contract, both fallback() and receive() functions are defined, and they both call the fund() function. This means that when Ether is sent to the contract without any data, the receive() function is called, and it automatically calls the fund() function to process the incoming Ether as a donation.

Here's an example:

Alice wants to send 1 Ether to the FundMe contract. She creates a transaction with her wallet, sets the recipient address to the FundMe contract address, and sets the value to 1 Ether. She does not include any data in the transaction.

When the Ethereum network processes Alice's transaction, it checks the FundMe contract for a receive() function, since the transaction does not include any data. It finds the receive() function and executes it. The receive() function, in turn, calls the fund() function to process Alice's 1 Ether as a donation to the funding campaign.

In summary, the fallback() and receive() functions in a Solidity smart contract are used to handle incoming Ether transactions that do not include any data or do not match any other functions in the contract. In the FundMe contract, both functions call the fund() function to process the incoming Ether as a donation to the funding campaign.

## Library

`using PriceConverter for uint256;`
The line using PriceConverter for uint256; is an example of using a Solidity library for a specific data type. In this case, the library PriceConverter is being attached to the uint256 data type. This allows you to use the library's functions as if they were methods of the uint256 data type.

A Solidity library is a collection of functions that can be reused across different contracts. They are designed to be efficient and help reduce the gas cost of contract execution. Libraries can be attached to specific data types, making it easier to use their functions with those data types.

In this example, the PriceConverter library probably contains functions to convert a value of type uint256 to a different unit or format. By using the using keyword, you can call these functions directly on uint256 variables.

The `PriceConverter library` here is a Solidity library that interacts with a Chainlink price feed to get the current ETH/USD conversion rate. It provides two functions: getPrice() and getConversionRate(uint256 ethAmount).

`getPrice()`: This function fetches the latest ETH/USD price from a Chainlink price feed. It uses the AggregatorV3Interface to interact with the price feed at the specified address (0x0000). It calls the latestRoundData() function on the price feed, which returns various data, including the current price (int256 answer). The function then converts the price to a uint256 value and multiplies it by 10^10 to adjust for the 18-digit representation of the price. The adjusted price is returned.
getConversionRate(uint256 ethAmount): This function takes an ethAmount (in wei) as input and calculates its equivalent value in USD using the current ETH/USD conversion rate fetched from the Chainlink price feed. It first calls the getPrice() function to get the current ETH/USD price, then multiplies the ethAmount by the price and divides the result by 10^18 (1e18) to obtain the equivalent USD value. The function returns this value as the conversion rate.
The `internal keyword in Solidity` is a `visibility modifier` that restricts the visibility of functions and state variables. Functions marked as internal can only be called from within the same contract or derived contracts (if the function is part of a contract, not a library). In the case of a library, like the PriceConverter, internal functions can only be called from contracts that use the library. This is useful when you want to limit the accessibility of functions to only the contracts that need them, hiding their implementation details from external callers.

In this PriceConverter library, both getPrice() and getConversionRate(uint256 ethAmount) functions are marked as internal. This means that these functions can only be called from contracts that use the PriceConverter library, and they cannot be called directly from an external source, such as another contract or a user interacting with the blockchain.

## Payable Keyword

```

    Address to which the funds will be sent
    address payable public fundsDestination;

```

he payable keyword in Solidity is used to specify that an address or a function can receive Ether. In the provided code snippet, address payable public fundsDestination;, the payable keyword is used with an address variable named fundsDestination. This means that the fundsDestination address is capable of receiving Ether.

In Solidity 0.5 and later versions, there are two types of addresses: regular address and address payable. A regular address type cannot directly receive Ether, while an address payable type can. This distinction was introduced to improve safety and clarify that not every address is eligible to receive Ether

When you want to send Ether to an address, you need to ensure that the address type is address payable. If you have a non-payable address and want to convert it to a payable address, you can do so using a ``type cast through uint160:`

```

address nonPayableAddress = ...;
address payable payableAddress = address(uint160(nonPayableAddress));

```

### Constructor and Struct

In Solidity, a constructor is a special function that is executed during the contract's creation. It's used to initialize the contract's state variables and perform any other setup tasks. In this fundme, the constructor is setting the contract's owner to the address that deployed the contract:

constructor() {
i_owner = msg.sender;
}

Here, `msg.sender` represents the address that deployed the contract, and `i_owner` is a state variable that stores the contract's owner address. This constructor ensures that the contract's owner is set to the address that deployed the contract ).

A `struct` is a custom data type in Solidity that allows you to define a set of properties for a single variable. In our cntract, a Funder struct is defined with two properties: `funderAddress` (an address) and `amountFunded` (a uint256):

```
struct Funder {
    address funderAddress;
    uint256 amountFunded;
}
```

You can create and use instances of this struct to store information about a funder within the contract. For example, you could create a new Funder instance like this:

`Funder memory newFunder = Funder(msg.sender, 100);`
This creates a new Funder instance with the sender's address and an amount funded of 100.

To further illustrate the use of structs, consider the example :

```
pragma solidity ^0.8.0;
contract test {
    struct Book {
        string title;
        string author;
        uint book_id;
    }
    Book book;
    function setBook() public {
        book = Book('Learn Java', 'TP', 1);
    }
    function getBookId() public view returns (uint) {
        return book.book_id;
    }
}
```

In this example, a Book struct is defined with three properties: title, author, and book_id. The contract has a state variable book of type Book, and two functions setBook and getBookId. The setBook function initializes the book state variable with a new Book instance, and the getBookId function returns the book_id of the stored book.

`Function modifiers`, like the onlyOwner modifier can be used to change the behavior of functions in a declarative way. In this case, the onlyOwner modifier checks if the sender of the transaction is the contract owner before allowing the function execution:

```
modifier onlyOwner {
    require(
        msg.sender == owner,
        "Only owner can call this function."
    );
    _;
}
```

This modifier can be applied to functions that should only be executed by the contract owner, such as the changePrice function in the Register contract:

```
function changePrice(uint \_price) public onlyOwner {
price = \_price;
}
```

By using the onlyOwner modifier, the changePrice function will only be executed if the transaction sender is the contract owner, ensuring that only the owner can change the price.

In Solidity, both the fallback and receive functions are special functions that a contract can have to handle situations where no other function matches the incoming request. Let's explore each of these functions in detail:

## Receive Function:

The receive function was introduced in Solidity 0.6.x as a special function that only triggers when the contract receives Ether without any function being explicitly called, i.e., when the calldata is empty.

Here is how it is generally defined:

```
receive() external payable {
	// code to execute
}
```

This function has to be external and payable, cannot have arguments, cannot return anything, and you can have at most one receive function in a contract.

If a contract receives Ether via regular transaction (that is, a transaction with empty calldata), and the contract has a defined receive function, that function is triggered. If no receive function exists but a payable fallback function does, then the fallback function is triggered.

## Fallback Function:

The fallback function is executed in two scenarios:

If a function is called on the contract, but no function in the contract matches the identifier in the calldata, the fallback function is executed.
If a contract receives Ether along with calldata for a function that does not exist, the fallback function is triggered.
Here is how it is generally defined:

```
fallback() external payable {
	// code to execute
}
```

Differences and Relationship:
The receive and fallback functions act as safety nets for a contract, catching Ether sent to the contract in non-standard ways. The main difference lies in when these functions are executed:

The receive function is specifically used for handling plain Ether transfers, i.e., transactions with empty calldata.
The fallback function is a more general catch-all function that is executed if no other function matches the function identifier, or if no data was provided with the function call.
Their relationship can be summarized in this way: in a situation where a contract receives Ether without any data and a receive function is defined, the receive function is triggered. If a receive function is not defined but a payable fallback function exists, then the fallback function is triggered. If neither a receive nor a payable fallback function are present, the contract can't receive Ether through regular transactions and throws an exception.

Thus, these functions work together to ensure that the contract can handle any unexpected Ether transfers robustly.
