# Ethereum Units and Subunits

This document provides a comprehensive understanding of the different units and subunits of Ethereum cryptocurrency, Ethereum (ETH), namely Ether, Wei, Gwei and their examples and usage scenarios. Also, it explains the default units that we encounter while dealing with smart contracts.

## Table of Contents

1. [Ether](#ether)
2. [Wei](#wei)
3. [Gwei](#gwei)
4. [Other Subunits](#other-subunits)
5. [Units in Smart Contracts](#units-in-smart-contracts)
6. [Best Practices](#best-practices)
7. [Resources](#resources)

## Ether<a name="ether"></a>

Ether is the primary and natural unit of currency in Ethereum. It's used to pay for transactions and computational services on the Ethereum network.

**Example**: If you own 1 Ether, that means you have 1 ETH in your digital wallet.

## Wei<a name="wei"></a>

Wei is the smallest subunit of ETH. It is often used to specify gas prices for Ethereum transactions.

1 Ether = 1e18 Wei

**Example**: If you are setting a low gas price for a transaction, you might set it to 1 Wei.

## Gwei<a name="gwei"></a>

Gwei, or Gigawei, is another subunit of ETH that is commonly used for gas prices.

1 Ether = 1e9 Gwei or

1 Gwei = 1e9 Wei

**Example**: A more typical gas price at times of low network congestion might be '20 Gwei'.

## Other Subunits<a name="other-subunits"></a>

There are many subunits of Ether, including: Finney, Szabo, Shannon, Babbage, Lovelace, and others. You can check the [Ethereum GitHub page](https://github.com/ethereum/web3.js/blob/0.15.0/lib/utils/utils.js#L40) for a comprehensive list.

Generally, however, most calculations and pricing are done in Ether, Gwei or Wei due to their common usage and ease of understanding.

## Units in Smart Contracts<a name="units-in-smart-contracts"></a>

In Ethereum smart contracts, the default unit for values is Wei. This is to avoid fractional numbers and rounding errors. For example, if you were to send 1 Ether in a function call, you would actually write it as 1e18 wei.

**Example**:

A function in a Solidity smart contract to send Ether might look like this

```
 function sendEther(address payable recipient) public payable { recipient.transfer(msg.value); //msg.value is in Wei
 }
```

## Best Practices<a name="best-practices"></a>

Some best practices when dealing with Ethereum units:

- Always clarify the units you're working with.
- When calculating gas prices, prefer to use Gwei as it is the most commonly used unit.
- Beware of rounding errors when doing calculations with Ether. Always double-check your math.

## Resources<a name="resources"></a>

1. [GitHub - Ethereum](https://ethereum.github.io/)
2. [Ether.World - Units](https://etherworld.co/2017/11/17/understanding-ethereum-units/)
3. [Ethereum Stackexchange - What is meant by the term 'Gas'?](https://ethereum.stackexchange.com/questions/3/what-is-meant-by-the-term-gas)
4. [Web3.js - Units](https://web3js.readthedocs.io/en/v1.2.11/web3-utils.html#id76)
