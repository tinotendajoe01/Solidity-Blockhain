# RawMaterial
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/RawMaterial.sol)

**Author:**
Tinotenda Joe

This contract is part of a supply chain protocol that allows managing the logistics of raw materials


## State Variables
### Owner

```solidity
address Owner;
```


### productid

```solidity
address productid;
```


### description

```solidity
bytes32 description;
```


### quantity

```solidity
uint256 quantity;
```


### transporter

```solidity
address transporter;
```


### manufacturer

```solidity
address manufacturer;
```


### supplier

```solidity
address supplier;
```


### status

```solidity
packageStatus status;
```


### packageReceiverDescription

```solidity
bytes32 packageReceiverDescription;
```


### txnContractAddress

```solidity
address txnContractAddress;
```


## Functions
### constructor

Construct a new RawMaterial contract


```solidity
constructor(
    address _creatorAddr,
    address _productid,
    bytes32 _description,
    uint256 _quantity,
    address _transporterAddr,
    address _manufacturerAddr
);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_creatorAddr`|`address`|the address of the creator|
|`_productid`|`address`|the ID of the product|
|`_description`|`bytes32`|the description of the product|
|`_quantity`|`uint256`|the quantity of the product|
|`_transporterAddr`|`address`|the address of the transporter|
|`_manufacturerAddr`|`address`|the address of the manufacturer|


### getSuppliedRawMaterials

Returns all the supplied raw materials


```solidity
function getSuppliedRawMaterials()
    public
    view
    returns (address, bytes32, uint256, address, address, address, address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|productid, description, quantity, supplier, transporter, manufacturer, txnContractAddress|
|`<none>`|`bytes32`||
|`<none>`|`uint256`||
|`<none>`|`address`||
|`<none>`|`address`||
|`<none>`|`address`||
|`<none>`|`address`||


### getRawMaterialStatus

Returns the status of the raw material


```solidity
function getRawMaterialStatus() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|status of the raw material|


### pickPackage

Pick a package from the supplier


```solidity
function pickPackage(address _transporterAddr) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_transporterAddr`|`address`|the address of the transporter|


### receivedPackage

Receive a package at the manufacturer


```solidity
function receivedPackage(address _manufacturerAddr) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_manufacturerAddr`|`address`|the address of the manufacturer|


## Events
### ShippmentUpdate
Reports a status update for the shipment


```solidity
event ShippmentUpdate(
    address indexed ProductID,
    address indexed Transporter,
    address indexed Manufacturer,
    uint256 TransporterType,
    uint256 Status
);
```

## Enums
### packageStatus
Possible statuses of a package


```solidity
enum packageStatus {
    atCreator,
    picked,
    delivered
}
```

