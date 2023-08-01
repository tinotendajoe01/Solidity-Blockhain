# BriteLedgersV1
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/BriteLedgersV1.sol)

**Inherits:**
[Supplier](/src/LedgerContracts/Supplier.sol/contract.Supplier.md), [Transporter](/src/LedgerContracts/Transporter.sol/contract.Transporter.md), [Manufacturer](/src/LedgerContracts/Manufacturer.sol/contract.Manufacturer.md), [Wholesaler](/src/LedgerContracts/Wholesaler.sol/contract.Wholesaler.md), [Distributor](/src/LedgerContracts/Distributor.sol/contract.Distributor.md), [FinalConsumer](/src/LedgerContracts/FinalConsumer.sol/contract.FinalConsumer.md)

*This contract models a supply chain process on the blockchain.
It includes multiple roles: supplier, transporter, manufacturer, wholesaler, distributor, and consumer.
Each role has its specific functions which can only be executed by an address assigned that role.
The contract uses a shared ledger to record every step of the process, making it transparent, secure, and efficient.
Unlike traditional supply chains, every stage of the process is recorded on the blockchain.
This contract is a part of the BriteLedgers protocol.*

*This contract adopts the owner and authorized user design pattern, it uses cryptography for secure communication and ensures trustless interaction
in the supply chain.*


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

*Creates a package of raw material.
Can only be executed by a supplier.*


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
|`_description`|`bytes32`|description of the raw material|
|`_quantity`|`uint256`|quantity of the raw material|
|`_transporterAddr`|`address`|address of the transporter|
|`_manufacturerAddr`|`address`|address of the manufacturer|


### supplierGetPackageCount


```solidity
function supplierGetPackageCount() external view returns (uint256);
```

### supplierGetRawMaterialAddresses


```solidity
function supplierGetRawMaterialAddresses() external view returns (address[] memory);
```

### transporterHandlePackage


```solidity
function transporterHandlePackage(address _address, uint256 transporterType, address cid) external;
```

### manufacturerReceivedRawMaterials


```solidity
function manufacturerReceivedRawMaterials(address _addr) external;
```

### manufacturerCreatesNewCommodity


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

### wholesalerReceivedCommodity


```solidity
function wholesalerReceivedCommodity(address _address) external;
```

### transferCommodityW_D


```solidity
function transferCommodityW_D(address _address, address transporter, address receiver) external;
```

### getBatchIdByIndexWD


```solidity
function getBatchIdByIndexWD(uint256 index) external view returns (address packageID);
```

### getSubContractWD


```solidity
function getSubContractWD(address _address) external view returns (address SubContractWD);
```

### distributorReceivedCommodity


```solidity
function distributorReceivedCommodity(address _address, address cid) external;
```

### distributorTransferCommoditytoFinalConsumer


```solidity
function distributorTransferCommoditytoFinalConsumer(address _address, address transporter, address receiver)
    external;
```

### getBatchesCountDC


```solidity
function getBatchesCountDC() external view returns (uint256 count);
```

### getBatchIdByIndexDC


```solidity
function getBatchIdByIndexDC(uint256 index) external view returns (address packageID);
```

### getSubContractDC


```solidity
function getSubContractDC(address _address) external view returns (address SubContractDP);
```

### consumerReceivedCommodity


```solidity
function consumerReceivedCommodity(address _address, address cid) external;
```

### updateStatus


```solidity
function updateStatus(address _address, uint256 Status) external;
```

### getSalesInfo


```solidity
function getSalesInfo(address _address) external view returns (uint256 Status);
```

### getBatchesCountC


```solidity
function getBatchesCountC() external view returns (uint256 count);
```

### getBatchIdByIndexC


```solidity
function getBatchIdByIndexC(uint256 index) external view returns (address _address);
```

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

