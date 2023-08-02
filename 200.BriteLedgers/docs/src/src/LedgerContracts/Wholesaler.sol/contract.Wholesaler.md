# Wholesaler
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/ff16ce828605953df6269c504e03d920866d1c6f/src/LedgerContracts/Wholesaler.sol)

**Author:**
Your Name

This contract manages the transfer of commodities from a wholesaler to a distributor.

*This contract interacts with the Commodity and CommodityW_D contracts.*


## State Variables
### CommoditiesAtWholesaler
Maps a wholesaler's address to an array of commodity addresses that the wholesaler has received.


```solidity
mapping(address => address[]) public CommoditiesAtWholesaler;
```


### CommodityWtoD
Maps a wholesaler's address to an array of CommodityW_D contract addresses that the wholesaler has initiated.


```solidity
mapping(address => address[]) public CommodityWtoD;
```


### CommodityWtoDTxContract
Maps a commodity's address to the CommodityW_D contract address that manages its transfer from a wholesaler to a distributor.


```solidity
mapping(address => address) public CommodityWtoDTxContract;
```


## Functions
### commodityRecievedAtWholesaler

Marks a commodity as received by the wholesaler.

*Calls the receivedCommodity function of the Commodity contract.*


```solidity
function commodityRecievedAtWholesaler(address _address) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the Commodity contract.|


### transferCommodityWtoD

Initiates the transfer of a commodity from the wholesaler to a distributor.

*Creates a new CommodityW_D contract for the transfer.*


```solidity
function transferCommodityWtoD(address _address, address transporter, address receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the Commodity contract.|
|`transporter`|`address`|The address of the transporter.|
|`receiver`|`address`|The address of the distributor.|


