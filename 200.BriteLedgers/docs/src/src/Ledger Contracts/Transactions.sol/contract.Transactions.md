# Transactions
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/cf463adb86eb681dea89cb8178867ce0ef041f33/src/Ledger Contracts/Transactions.sol)

**Author:**
Tinotenda Joe

*A contract for creating and retrieving transaction entries.*


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

Throws if the previous transaction hash does not match with last transaction's hash

*Creates a new transaction entry.*


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

### getAllTransactions

*Retrieves all transaction entries.*


```solidity
function getAllTransactions() public view returns (transactions[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`transactions[]`|An array of all transaction entries.|


### getAllTransactionsCount


```solidity
function getAllTransactionsCount() public view returns (uint256);
```

### getTransaction


```solidity
function getTransaction(uint256 id)
    public
    view
    returns (bytes32, address, address, bytes32, string memory, string memory, uint256);
```

## Events
### transactionCreated
*Emitted when a new transaction entry is created.*


```solidity
event transactionCreated(
    bytes32 _transactionHash, address _from, address _to, bytes32 _prevTransaction, string _latitude, string _longitude
);
```

## Errors
### TRANSACTION_ERROR_OCCURRED
*Error message for transaction validation failure.*


```solidity
error TRANSACTION_ERROR_OCCURRED();
```

## Structs
### transactions
*Struct for storing transaction information.*


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

