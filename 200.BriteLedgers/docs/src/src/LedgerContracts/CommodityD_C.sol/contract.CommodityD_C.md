# CommodityD_C
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/CommodityD_C.sol)

**Author:**
Tinotenda Joe

This contract represents a dispatch and collection model for commodities


## State Variables
### Owner
*Storage for contract owner's address*


```solidity
address Owner;
```


### medAddr
Addresses for medAddr, sender, transporter, receiver


```solidity
address medAddr;
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
*Store the status of package*


```solidity
packageStatus status;
```


## Functions
### constructor

*Constructor that initializes contract with initial parameters*


```solidity
constructor(address _address, address Sender, address Transporter, address Receiver);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The medAddr|
|`Sender`|`address`|The sender's address|
|`Transporter`|`address`|The transporter's address|
|`Receiver`|`address`|The receiver's address|


### pickDC

Called when the associated transporter initiates this function


```solidity
function pickDC(address _address, address transporterAddr) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The commodity address|
|`transporterAddr`|`address`|The transporter's address|


### receiveDC

Called when the associated receiver initiates this function


```solidity
function receiveDC(address _address, address Receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The commodity address|
|`Receiver`|`address`|The receiver's address|


### get_addressStatus

Returns the current status of the package


```solidity
function get_addressStatus() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|status The current status of the package|


## Errors
### UnAuthorised_Receiver

```solidity
error UnAuthorised_Receiver();
```

### Transporter_is_not_Authorised

```solidity
error Transporter_is_not_Authorised();
```

## Enums
### packageStatus
*Enumeration of different package statuses*


```solidity
enum packageStatus {
    atcreator,
    picked,
    delivered
}
```

