# Commodity
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/cf463adb86eb681dea89cb8178867ce0ef041f33/src/LedgerContracts/Commodity.sol)

This contract represents a commodity in a supply chain.

*It includes functions for managing the commodity's status and the parties involved in its shipment.*


## State Variables
### Owner

```solidity
address Owner;
```


### description

```solidity
bytes32 description;
```


### rawMaterials

```solidity
address[] rawMaterials;
```


### transporters

```solidity
address[] transporters;
```


### manufacturer

```solidity
address manufacturer;
```


### wholesaler

```solidity
address wholesaler;
```


### distributor

```solidity
address distributor;
```


### customer

```solidity
address customer;
```


### quantity

```solidity
uint256 quantity;
```


### status

```solidity
commodityStatus status;
```


### txnContractAddress

```solidity
address txnContractAddress;
```


## Functions
### constructor

Creates a new commodity batch.


```solidity
constructor(
    address _manufacturerAddr,
    bytes32 _description,
    address[] memory _rawAddr,
    uint256 _quantity,
    address[] memory _transporterAddr,
    address _receiverAddr,
    uint256 RcvrType
);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_manufacturerAddr`|`address`|The address of the manufacturer creating the batch.|
|`_description`|`bytes32`|A brief description of the batch.|
|`_rawAddr`|`address[]`|An array of addresses representing the raw materials used in the batch.|
|`_quantity`|`uint256`|The quantity of commodity in the batch.|
|`_transporterAddr`|`address[]`|An array of addresses representing the transporters involved in the shipment.|
|`_receiverAddr`|`address`|The address of the receiver of the batch.|
|`RcvrType`|`uint256`|An identifier for the type of receiver (1 for wholesaler, 2 for distributor).|


### getCommodityInfo

Returns information about the commodity batch.


```solidity
function getCommodityInfo()
    public
    view
    returns (
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint256 _quantity,
        address[] memory _transporterAddr,
        address _distributor,
        address _customer
    );
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_manufacturerAddr`|`address`|The address of the manufacturer.|
|`_description`|`bytes32`|A brief description of the commodity batch.|
|`_rawAddr`|`address[]`|An array of addresses representing the raw materials used in the batch.|
|`_quantity`|`uint256`|The quantity of commodity in the batch.|
|`_transporterAddr`|`address[]`|An array of addresses representing the transporters involved in the shipment.|
|`_distributor`|`address`|The address of the distributor.|
|`_customer`|`address`|The address of the customer.|


### getWDC

Returns the addresses of the wholesaler, distributor, and customer.


```solidity
function getWDC() public view returns (address[3] memory WDP);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`WDP`|`address[3]`|An array of 3 addresses representing the wholesaler, distributor, and customer.|


### getBatchIDStatus

Returns the current status of the commodity batch.


```solidity
function getBatchIDStatus() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|A uint representing the current status of the commodity batch.|


### pickCommodity

Updates the status of the commodity batch when it is picked up by a transporter.


```solidity
function pickCommodity(address _transporterAddr) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_transporterAddr`|`address`|The address of the transporter picking up the commodity.|


### updateTransporterArray

Adds a transporter to the array of transporters involved in the shipment.


```solidity
function updateTransporterArray(address _transporterAddr) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_transporterAddr`|`address`|The address of the transporter to add.|


### receivedCommodity

Updates the status of the commodity batch when it is received by a wholesaler or distributor.


```solidity
function receivedCommodity(address _receiverAddr) public returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_receiverAddr`|`address`|The address of the receiver (either wholesaler or distributor).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|A uint representing the new status of the commodity batch.|


### sendWtoD

Updates the distributor address and status of the commodity batch when it is sent from the wholesaler to the distributor.


```solidity
function sendWtoD(address receiver, address sender) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|The address of the distributor.|
|`sender`|`address`|The address of the wholesaler.|


### receivedWtoD

Updates the status of the commodity batch when it is received by the distributor from the wholesaler.


```solidity
function receivedWtoD(address receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|The address of the distributor.|


### sendDtoC

Updates the customer address and status of the commodity batch when it is sent from the distributor to the customer.


```solidity
function sendDtoC(address receiver, address sender) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|The address of the customer.|
|`sender`|`address`|The address of the distributor.|


### receivedDtoC

Updates the status of the commodity batch when it is received by the customer from the distributor.


```solidity
function receivedDtoC(address receiver) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|The address of the customer.|


## Events
### ShippmentUpdate
Emitted when there is an update to the shipment status.


```solidity
event ShippmentUpdate(
    address indexed BatchID, address indexed Shipper, address indexed Receiver, uint256 TransporterType, uint256 Status
);
```

## Errors
### UnAuthorised_PickUp

```solidity
error UnAuthorised_PickUp();
```

### Only_Wholesaler_or_Distributor_Authorised

```solidity
error Only_Wholesaler_or_Distributor_Authorised();
```

### Product_not_picked_up_yet

```solidity
error Product_not_picked_up_yet();
```

### Wholesaler_is_not_Associated

```solidity
error Wholesaler_is_not_Associated();
```

### Distributor_is_not_Associated

```solidity
error Distributor_is_not_Associated();
```

### Customer_is_not_Associated

```solidity
error Customer_is_not_Associated();
```

### Package_at_Manufacturer

```solidity
error Package_at_Manufacturer();
```

## Enums
### commodityStatus
Represents the status of a commodity in the supply chain.


```solidity
enum commodityStatus {
    atManufacturer,
    pickedForW,
    pickedForD,
    deliveredAtW,
    deliveredAtD,
    pickedForC,
    deliveredAtC
}
```

