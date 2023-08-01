# FinalConsumer
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/FinalConsumer.sol)

**Author:**
Tinotenda Joe

This contract manages the commodities received by Consumers and track of their sales status


## State Variables
### CommodityBatchAtFinalConsumer
Tracks the commodities at the Consumer

*mapping of Consumer address to array of addresses*


```solidity
mapping(address => address[]) public CommodityBatchAtFinalConsumer;
```


### sale
Tracks the sale status of commodities

*mapping of address to sale status*


```solidity
mapping(address => salestatus) public sale;
```


## Functions
### commodityRecievedAtFinalConsumer

Function to be called when the Consumer receives a commodity


```solidity
function commodityRecievedAtFinalConsumer(address _address, address cid) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`cid`|`address`|The identifier for the commodity|


### updateSaleStatus

Function to update the sale status of a commodity


```solidity
function updateSaleStatus(address _address, uint256 Status) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`Status`|`uint256`|The status of the sale|


### salesInfo

Function to get sales information for a given commodity


```solidity
function salesInfo(address _address) public view returns (uint256 Status);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`Status`|`uint256`|The status of the sale|


## Events
### CommodityStatus
Event to be emitted when commodity status changes

*Event includes the commodity address, Consumer's address and status*


```solidity
event CommodityStatus(address _address, address indexed Consumer, uint256 status);
```

## Enums
### salestatus
*Enumeration for possible statuses of the sale*


```solidity
enum salestatus {
    notfound,
    atConsumer,
    sold,
    expired,
    damaged
}
```

