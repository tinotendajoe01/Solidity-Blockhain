# Transactions
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/ff16ce828605953df6269c504e03d920866d1c6f/src/LedgerContracts/Transactions.sol)

**Author:**
Tinotenda Joe

This contract serves as a decentralized ledger for recording transactions within a supply chain protocol. It supports creating, retrieval, and count tracking of transaction entries.


## State Variables
### Owner

```solidity
address public Owner;
```


### transactionCount

```solidity
uint256 public transactionCount;
```


### txns

```solidity
mapping(uint256 => transactions) public txns;
```


## Functions
### constructor


```solidity
constructor(address _manufacturerAddr);
```

### createTransactionEntry

Increases the total transaction count and emits an event at the end. Validates previous transaction for all transactions other than the first one.

*Establishes a new transaction entry in the ledger*


```solidity
function createTransactionEntry(
    bytes32 _transactionHash,
    address _from,
    address _to,
    bytes32 _prevTransaction,
    string memory _latitude,
    string memory _longitude
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_transactionHash`|`bytes32`|Id of the transaction|
|`_from`|`address`|Source address of the transaction|
|`_to`|`address`|Destination address for the transaction|
|`_prevTransaction`|`bytes32`|Hash of the previous transaction to maintain continuity|
|`_latitude`|`string`|Latitude of the transaction|
|`_longitude`|`string`|Longitude of the transaction|


### getAllTransactions

*Fetch all the transaction entries recorded in the ledger*


```solidity
function getAllTransactions() public view returns (transactions[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`transactions[]`|Array containing all the transactions in the ledger|


### getAllTransactionsCount

*Retrieves the total count of transactions in the ledger*


```solidity
function getAllTransactionsCount() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Total count of transactions|


### getTransaction

*Fetches the details of a specific transaction by its index*


```solidity
function getTransaction(uint256 id)
    public
    view
    returns (bytes32, address, address, bytes32, string memory, string memory, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`uint256`|Index of the transaction to fetch|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Transaction details: hash, source address, destination address, previous transaction, latitude, longitude, timestamp|
|`<none>`|`address`||
|`<none>`|`address`||
|`<none>`|`bytes32`||
|`<none>`|`string`||
|`<none>`|`string`||
|`<none>`|`uint256`||


## Events
### transactionCreated
*Event emitted once a transaction gets created successfully*


```solidity
event transactionCreated(
    bytes32 _transactionHash, address _from, address _to, bytes32 _prevTransaction, string _latitude, string _longitude
);
```

## Errors
### TRANSACTION_ERROR_OCCURRED

```solidity
error TRANSACTION_ERROR_OCCURRED();
```

## Structs
### transactions
*Represents a transaction in the ledger with respective details*


```solidity
struct transactions {
    bytes32 transactionHash;
    address fromAddr;
    address toAddr;
    bytes32 prevTransaction;
    string latitude;
    string longitude;
    uint256 timestamp;
}
```

