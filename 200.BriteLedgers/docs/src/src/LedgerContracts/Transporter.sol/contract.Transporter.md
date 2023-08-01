# Transporter
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/LedgerContracts/Transporter.sol)

**Author:**
Tinotenda Joe

This contract manages the handling of packages in the supply chain


## Functions
### handlePackage

Function to handle picking of packages


```solidity
function handlePackage(address _addr, uint256 transportertype, address cid) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_addr`|`address`|The address of the package origin|
|`transportertype`|`uint256`|The type of transporter (1- Supplier to Manufacturer, 2 - Manufacturer to Wholesaler, 3 - Wholesaler to Distributer, 4 - Distributer to Customer)|
|`cid`|`address`|The identifier for the commodity|


