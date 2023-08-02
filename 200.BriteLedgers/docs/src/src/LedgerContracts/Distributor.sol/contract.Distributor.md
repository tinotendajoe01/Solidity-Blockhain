# Distributor
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/ff16ce828605953df6269c504e03d920866d1c6f/src/LedgerContracts/Distributor.sol)

**Author:**
Tinotenda Joe

This contract manages commodities received by distributor and their transfer


## State Variables
### CommoditysAtDistributor
Track commodities at distributor's address

*Mapping of distributor's address to array of commodity addresses*


```solidity
mapping(address => address[]) public CommoditysAtDistributor;
```


### CommodityDtoC
Track transfer of commodities from distributor to customer

*Mapping of distributor's address to array of CommodityD_C contract addresses*


```solidity
mapping(address => address[]) public CommodityDtoC;
```


### CommodityDtoCTxContract
Track individual commodity transfer contracts

*Mapping of commodity address to CommodityD_C contract address*


```solidity
mapping(address => address) public CommodityDtoCTxContract;
```


## Functions
### commodityRecievedAtDistributor

Function to be called when a commodity is received at the distributor


```solidity
function commodityRecievedAtDistributor(address _address, address cid) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`cid`|`address`|The identifier for the commodity|


### transferCommodityDtoC

Function to transfer commodity from distributor to customer


```solidity
function transferCommodityDtoC(address _address, address transporter, address receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`transporter`|`address`|The transporter's address|
|`receiver`|`address`|The receiver or customer's address|


