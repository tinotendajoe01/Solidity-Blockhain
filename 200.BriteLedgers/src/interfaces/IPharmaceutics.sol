// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

interface IPharmaceutics {
    struct Drug {
        string name;
        string description;
        address manufacturer;
        address currentOwner;
        address[] ownershipChain;
        bool authenticityStatus;
    }

    struct Order {
        uint256 drugId;
        address buyer;
        address seller;
        bool fulfillmentStatus;
    }

    function addDrug(string memory name, string memory description) external;
    function transferDrugOwnership(uint256 drugId, address recipient) external;
    function placeOrder(uint256 drugId, address seller) external;
    function fulfillOrder(uint256 orderId) external;

    function drugs(uint256) external view returns (Drug memory);
    function orders(uint256) external view returns (Order memory);
    function drugCounter() external view returns (uint256);
    function orderCounter() external view returns (uint256);

    event DrugAdded(uint256 indexed drugId, string name, string description, address manufacturer);
    event DrugTransfer(uint256 indexed drugId, address indexed from, address indexed to);
    event OwnershipChainUpdated(uint256 indexed drugId, address[] ownershipChain);
    event OrderPlaced(uint256 indexed orderId, uint256 drugId, address indexed buyer, address indexed seller);
}
