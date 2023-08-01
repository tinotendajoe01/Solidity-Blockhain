# Manufacturer
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/Manufacturer.sol)

**Author:**
Anonymous

This contract manages the receipt and creation of commodities by a manufacturer


## State Variables
### manufacturerRawMaterials
Track the raw materials owned by manufacturers

*Mapping of manufacturer's address to array of RawMaterial contract addresses*


```solidity
mapping(address => address[]) public manufacturerRawMaterials;
```


### manufacturerCommodities
Track the commodities produced by manufacturers

*Mapping of manufacturer's address to array of Commodity contract addresses*


```solidity
mapping(address => address[]) public manufacturerCommodities;
```


## Functions
### manufacturerReceivedPackage

Function called when a manufacturer receives a package of raw materials


```solidity
function manufacturerReceivedPackage(address _addr, address _manufacturerAddress) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_addr`|`address`|The address of the RawMaterial contract|
|`_manufacturerAddress`|`address`|The address of the manufacturer|


### manufacturerCreatesCommodity

Function called when a manufacturer creates a new commodity


```solidity
function manufacturerCreatesCommodity(
    address _manufacturerAddr,
    bytes32 _description,
    address[] memory _rawAddr,
    uint256 _quantity,
    address[] memory _transporterAddr,
    address _recieverAddr,
    uint256 RcvrType
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_manufacturerAddr`|`address`|The address of the manufacturer|
|`_description`|`bytes32`|The description of the commodity|
|`_rawAddr`|`address[]`|The array of addresses of raw materials used for the commodity|
|`_quantity`|`uint256`|The quantity of the commodity|
|`_transporterAddr`|`address[]`|The array of addresses of transporters for the commodity|
|`_recieverAddr`|`address`|The address of the receiver of the commodity|
|`RcvrType`|`uint256`|The type of the receiver (encoded as a uint256)|


