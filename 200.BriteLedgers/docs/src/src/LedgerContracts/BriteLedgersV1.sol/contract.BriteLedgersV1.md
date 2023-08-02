# BriteLedgersV1
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/ff16ce828605953df6269c504e03d920866d1c6f/src/LedgerContracts/BriteLedgersV1.sol)

**Inherits:**
[Supplier](/src/LedgerContracts/Supplier.sol/contract.Supplier.md), [Transporter](/src/LedgerContracts/Transporter.sol/contract.Transporter.md), [Manufacturer](/src/LedgerContracts/Manufacturer.sol/contract.Manufacturer.md), [Wholesaler](/src/LedgerContracts/Wholesaler.sol/contract.Wholesaler.md), [Distributor](/src/LedgerContracts/Distributor.sol/contract.Distributor.md), [FinalConsumer](/src/LedgerContracts/FinalConsumer.sol/contract.FinalConsumer.md)

**Author:**
Tinotenda Joe

The contract's core is a 'Tokenized Shared Ledger' that logs every transaction and interaction in the supply chain. This ledger provides an immutable, transparent, and verifiable record of the entire process, from the supplier to the consumer.

The contract can connect with existing off-chain, legacy supply chain systems. It incorporates both on and off-chain security measures to protect sensitive data while maintaining its transparent and traceable nature .

*This contract  models multiple roles within the supply chain: Supplier, Transporter, Manufacturer, Wholesaler, Distributor, and Consumer. Each role is tied to a unique address and has role-specific functions.*

*The contract integrates the Industrial Internet of Things (IIOT) for real-time data monitoring and recording at various stages of the supply chain. .*


## State Variables
### Owner
Owner of the contract


```solidity
address public Owner;
```


### userInfo
Mapping from address to userData


```solidity
mapping(address => userData) public userInfo;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyOwner

Ensures that only the owner can call the function


```solidity
modifier onlyOwner();
```

### checkUser

Validates handed-over users


```solidity
modifier checkUser(address addr);
```

### registerUser

*Registers a user with a given name, location, role, and address.
Can only be executed by the owner of the contract.
Emits a UserRegister event after successful registration.*


```solidity
function registerUser(bytes32 name, string[] memory loc, uint256 role, address _userAddr) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`bytes32`|user's name|
|`loc`|`string[]`|user's location|
|`role`|`uint256`|user's role|
|`_userAddr`|`address`|user's address|


### changeUserRole

*Allows the owner to change the role of a user.*


```solidity
function changeUserRole(uint256 _role, address _addr) external onlyOwner returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_role`|`uint256`|The new role of the user.|
|`_addr`|`address`|The address of the user.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|Status of the operation.|


### getUserInfo

*Allows the owner to get the user information of the given address.*


```solidity
function getUserInfo(address _address) external view onlyOwner returns (userData memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|Address of the user.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`userData`|User information.|


### supplierCreatesRawPackage

Creates a package of raw material

*Can only be executed by a supplier*


```solidity
function supplierCreatesRawPackage(
    bytes32 _description,
    uint256 _quantity,
    address _transporterAddr,
    address _manufacturerAddr
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_description`|`bytes32`|Description of the raw material|
|`_quantity`|`uint256`|Quantity of the raw material|
|`_transporterAddr`|`address`|Address of the transporter|
|`_manufacturerAddr`|`address`|Address of the manufacturer|


### supplierGetPackageCount

Returns the count of packages created by the supplier

*Can only be executed by a supplier*


```solidity
function supplierGetPackageCount() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of packages created by the supplier|


### supplierGetRawMaterialAddresses

Returns the addresses of all packages created by the supplier

*Can only be executed by a supplier*


```solidity
function supplierGetRawMaterialAddresses() external view returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of addresses of all packages created by the supplier|


### transporterHandlePackage

Handles the package by the transporter

*Can only be executed by a transporter*


```solidity
function transporterHandlePackage(address _address, uint256 transporterType, address cid) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the package|
|`transporterType`|`uint256`|The type of the transporter|
|`cid`|`address`|The id of the commodity|


### manufacturerReceivedRawMaterials

Handles the receipt of raw materials by the manufacturer

*Can only be executed by a manufacturer*


```solidity
function manufacturerReceivedRawMaterials(address _addr) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_addr`|`address`|The address of the raw material package|


### manufacturerCreatesNewCommodity

Creates a new commodity by the manufacturer

*Can only be executed by a manufacturer*


```solidity
function manufacturerCreatesNewCommodity(
    bytes32 _description,
    address[] memory _rawAddr,
    uint256 _quantity,
    address[] memory _transporterAddr,
    address _receiverAddr,
    uint256 RcvrType
) external returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_description`|`bytes32`|The description of the commodity|
|`_rawAddr`|`address[]`|The addresses of the raw materials|
|`_quantity`|`uint256`|The quantity of the commodity|
|`_transporterAddr`|`address[]`|The addresses of the transporters|
|`_receiverAddr`|`address`|The address of the receiver|
|`RcvrType`|`uint256`|The type of the receiver|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|A message indicating the commodity has been created|


### wholesalerReceivedCommodity

Handles the receipt of a commodity by the wholesaler

*Can only be executed by a wholesaler or a distributor*


```solidity
function wholesalerReceivedCommodity(address _address) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|


### transferCommodityW_D

Transfers a commodity from a wholesaler to a distributor

*Can only be executed by a wholesaler or the current owner of the package*


```solidity
function transferCommodityW_D(address _address, address transporter, address receiver) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`transporter`|`address`|The address of the transporter|
|`receiver`|`address`|The address of the receiver|


### getBatchIdByIndexWD

Returns the batch id by index for a wholesaler

*Can only be executed by a wholesaler*


```solidity
function getBatchIdByIndexWD(uint256 index) external view returns (address packageID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`index`|`uint256`|The index of the batch|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`packageID`|`address`|The id of the package|


### getSubContractWD

Returns the sub contract for a wholesaler

*Can only be executed by a wholesaler*


```solidity
function getSubContractWD(address _address) external view returns (address SubContractWD);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the wholesaler|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`SubContractWD`|`address`|The address of the sub contract|


### distributorReceivedCommodity

This function is called when a distributor receives a commodity

*Only a distributor or the current owner of the package can call this function*


```solidity
function distributorReceivedCommodity(address _address, address cid) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the distributor|
|`cid`|`address`|The commodity id|


### distributorTransferCommoditytoFinalConsumer

This function transfers a commodity from a distributor to a final consumer

*Only a distributor or the current owner of the package can call this function*


```solidity
function distributorTransferCommoditytoFinalConsumer(address _address, address transporter, address receiver)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`transporter`|`address`|The address of the transporter|
|`receiver`|`address`|The address of the receiver|


### getBatchesCountDC

This function returns the count of batches for a distributor

*Only a distributor can call this function*


```solidity
function getBatchesCountDC() external view returns (uint256 count);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`count`|`uint256`|The count of batches|


### getBatchIdByIndexDC

This function returns the batch id by index for a distributor

*Only a distributor can call this function*


```solidity
function getBatchIdByIndexDC(uint256 index) external view returns (address packageID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`index`|`uint256`|The index of the batch|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`packageID`|`address`|The id of the package|


### getSubContractDC

This function returns the sub contract for a distributor


```solidity
function getSubContractDC(address _address) external view returns (address SubContractDP);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the distributor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`SubContractDP`|`address`|The address of the sub contract|


### consumerReceivedCommodity

This function is called when a consumer receives a commodity

*Only a consumer can call this function*


```solidity
function consumerReceivedCommodity(address _address, address cid) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the consumer|
|`cid`|`address`|The commodity id|


### updateStatus

This function updates the status of a commodity

*Only the consumer or the current owner of the package can call this function*


```solidity
function updateStatus(address _address, uint256 Status) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the commodity|
|`Status`|`uint256`|The new status of the commodity|


### getBatchesCountC

This function returns the count of batches for a consumer

*Only a wholesaler or the current owner of the package can call this function*


```solidity
function getBatchesCountC() external view returns (uint256 count);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`count`|`uint256`|The count of batches|


### getBatchIdByIndexC

This function returns the batch id by index for a consumer

*Only a wholesaler or the current owner of the package can call this function*


```solidity
function getBatchIdByIndexC(uint256 index) external view returns (address _address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`index`|`uint256`|The index of the batch|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address of the batch|


### verify

This function verifies a signature


```solidity
function verify(address p, bytes32 hash, uint8 v, bytes32 r, bytes32 s) external pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`address`|The address that is claimed to be the signer|
|`hash`|`bytes32`|The hash of the signed message|
|`v`|`uint8`|The recovery id of the signature|
|`r`|`bytes32`|The r value of the signature|
|`s`|`bytes32`|The s value of the signature|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool Whether the signature is valid or not|


## Events
### UserRegister
Events to make the smart contract interaction transparent


```solidity
event UserRegister(address indexed _address, bytes32 name);
```

### buyEvent

```solidity
event buyEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);
```

### respondEvent

```solidity
event respondEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);
```

### sendEvent

```solidity
event sendEvent(address seller, address buyer, address packageAddr, bytes32 signature, uint256 indexed now);
```

### receivedEvent

```solidity
event receivedEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);
```

## Structs
### userData
Struct to define a user


```solidity
struct userData {
    bytes32 name;
    string[] userLoc;
    roles role;
    address userAddr;
}
```

## Enums
### roles
*Enum which defines the different actors in the system*


```solidity
enum roles {
    noRole,
    supplier,
    transporter,
    manufacturer,
    wholesaler,
    distributor,
    consumer
}
```

