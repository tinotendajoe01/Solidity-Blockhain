# Supplier
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/ff16ce828605953df6269c504e03d920866d1c6f/src/LedgerContracts/Supplier.sol)

**Author:**
Tinotenda Joe

This contract serves as a decentralized platform for suppliers to manage their raw materials in a supply chain protocol.

*Following is just a simple explanation, consider implementing more complex logic in accordance with your needs.*


## State Variables
### supplierRawMaterials

```solidity
mapping(address => address[]) public supplierRawMaterials;
```


## Functions
### createRawMaterialPackage

Create a new raw material package

*Constructor to set the initial storage*

*Ensure the proper access controls and error handling (if needed), add events to capture the important state changes
TODO: Require checks can be added for inputs*


```solidity
function createRawMaterialPackage(
    bytes32 _description,
    uint256 _quantity,
    address _transporterAddr,
    address _manufacturerAddr
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_description`|`bytes32`|the description of the raw material|
|`_quantity`|`uint256`|the quantity of the raw material|
|`_transporterAddr`|`address`|the address of the transporter|
|`_manufacturerAddr`|`address`|the address of the manufacturer|


### getNoOfPackagesOfSupplier

Get the number of packages of a supplier

*This can be used to quickly check how many packages a supplier has
TODO: Consider returning more detailed information about each package*


```solidity
function getNoOfPackagesOfSupplier() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|the number of packages of the supplier|


### getAllPackages

Get all packages of a supplier

*Access controls can be added here to restrict this sensitive information
TODO: Access Controls using OpenZeppelin's AccessControl.sol
TODO: Consider returning more detailed information about each package*


```solidity
function getAllPackages() public view returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|an array of addresses of the packages of the supplier|


## Events
### RawMaterialCreated

```solidity
event RawMaterialCreated(address indexed rawMaterialAddress, address indexed supplier);
```

