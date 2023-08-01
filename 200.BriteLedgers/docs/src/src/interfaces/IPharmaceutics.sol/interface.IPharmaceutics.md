# IPharmaceutics
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/eacbf6f1ab8174a4c8abbfec3ad125841d672252/src/interfaces/IPharmaceutics.sol)


## Functions
### addDrug


```solidity
function addDrug(string memory name, string memory description) external;
```

### transferDrugOwnership


```solidity
function transferDrugOwnership(uint256 drugId, address recipient) external;
```

### placeOrder


```solidity
function placeOrder(uint256 drugId, address seller) external;
```

### fulfillOrder


```solidity
function fulfillOrder(uint256 orderId) external;
```

### drugs


```solidity
function drugs(uint256) external view returns (Drug memory);
```

### orders


```solidity
function orders(uint256) external view returns (Order memory);
```

### drugCounter


```solidity
function drugCounter() external view returns (uint256);
```

### orderCounter


```solidity
function orderCounter() external view returns (uint256);
```

## Events
### DrugAdded

```solidity
event DrugAdded(uint256 indexed drugId, string name, string description, address manufacturer);
```

### DrugTransfer

```solidity
event DrugTransfer(uint256 indexed drugId, address indexed from, address indexed to);
```

### OwnershipChainUpdated

```solidity
event OwnershipChainUpdated(uint256 indexed drugId, address[] ownershipChain);
```

### OrderPlaced

```solidity
event OrderPlaced(uint256 indexed orderId, uint256 drugId, address indexed buyer, address indexed seller);
```

## Structs
### Drug

```solidity
struct Drug {
    string name;
    string description;
    address manufacturer;
    address currentOwner;
    address[] ownershipChain;
    bool authenticityStatus;
}
```

### Order

```solidity
struct Order {
    uint256 drugId;
    address buyer;
    address seller;
    bool fulfillmentStatus;
}
```

