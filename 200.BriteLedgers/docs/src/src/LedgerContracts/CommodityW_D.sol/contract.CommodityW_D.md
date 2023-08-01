# CommodityW_D
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/CommodityW_D.sol)

**Author:**
Tinotenda Joe

This contract represents a shipping model for commodities


## State Variables
### Owner
*Store the contract owner's address*


```solidity
address Owner;
```


### commodityId
Addresses for commodityId, sender, transporter, receiver


```solidity
address commodityId;
```


### sender

```solidity
address sender;
```


### transporter

```solidity
address transporter;
```


### receiver

```solidity
address receiver;
```


### status
*Stores the current package status*


```solidity
packageStatus status;
```


## Functions
### constructor

*Setup the contract with initial details*


```solidity
constructor(address _address, address Sender, address Transporter, address Receiver);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The commodity address|
|`Sender`|`address`|The sender's address|
|`Transporter`|`address`|The transporter's address|
|`Receiver`|`address`|The receiver's address|


### pickWD

Called when the transporter picks the package


```solidity
function pickWD(address _address, address _transporter) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The commodity address|
|`_transporter`|`address`|The transporter's address|


### receiveWD

Called when the receiver receives the package


```solidity
function receiveWD(address _address, address Receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The commodity address|
|`Receiver`|`address`|The receiver's address|


### getBatchIDStatus

Returns the current status of the package


```solidity
function getBatchIDStatus() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|status The current status of the package|


## Errors
### UnAUthorised_Receivers_Account
*Thrown when an unauthorized receiver's account is used*


```solidity
error UnAUthorised_Receivers_Account();
```

### UnAUthorised_Shippers_Account
*Thrown when an unauthorized shipper's account is used*


```solidity
error UnAUthorised_Shippers_Account();
```

## Enums
### packageStatus
*Enumeration of various package statuses*


```solidity
enum packageStatus {
    atcreator,
    picked,
    delivered
}
```

