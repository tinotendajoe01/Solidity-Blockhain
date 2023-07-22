// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract Pharmaceutics {
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
        uint256 quantity;
        address buyer;
        address seller;
        bool fulfillmentStatus;
    }

    mapping(uint256 => Drug) public drugs;
    mapping(uint256 => Order) public orders;
    mapping(uint256 => uint256) public drugInventories;
    mapping(uint256 => uint256) public drugPrices;
    mapping(address => uint256[]) public sellerRatings;
    mapping(address => string[]) public sellerReviews;

    uint256 public drugCounter;
    uint256 public orderCounter;

    event DrugAdded(uint256 indexed drugId, string name, string description, address manufacturer);
    event DrugTransfer(uint256 indexed drugId, address indexed from, address indexed to);
    event OwnershipChainUpdated(uint256 indexed drugId, address[] ownershipChain);
    event OrderPlaced(uint256 indexed orderId, uint256 drugId, address indexed buyer, address indexed seller);

    constructor() {
        drugCounter = 0;
        orderCounter = 0;
    }

    function addDrug(string memory name, string memory description) public {
        drugCounter++;
        drugs[drugCounter] = Drug(name, description, msg.sender, msg.sender, new address[](0), true);
        emit DrugAdded(drugCounter, name, description, msg.sender);
    }

    function addInventory(uint256 drugId, uint256 quantity) public {
        require(drugs[drugId].manufacturer == msg.sender, "Only the manufacturer can add inventory");
        drugInventories[drugId] += quantity;
    }

    function removeInventory(uint256 drugId, uint256 quantity) public {
        require(drugs[drugId].manufacturer == msg.sender, "Only the manufacturer can remove inventory");
        require(drugInventories[drugId] >= quantity, "Not enough inventory");
        drugInventories[drugId] -= quantity;
    }

    function setPrice(uint256 drugId, uint256 price) public {
        require(drugs[drugId].manufacturer == msg.sender, "Only the manufacturer can set the price");
        drugPrices[drugId] = price;
    }

    function transferDrugOwnership(uint256 drugId, address recipient) public {
        Drug storage drug = drugs[drugId];
        require(drug.currentOwner == msg.sender, "Only the current owner can transfer the drug");
        drug.ownershipChain.push(recipient);
        drug.currentOwner = recipient;
        emit DrugTransfer(drugId, msg.sender, recipient);
        emit OwnershipChainUpdated(drugId, drug.ownershipChain);
    }

    function placeOrder(uint256 drugId, uint256 quantity, address seller) public {
        require(drugInventories[drugId] >= quantity, "Not enough inventory");
        require(drugs[drugId].currentOwner == seller, "The seller does not own the drug");
        orderCounter++;
        orders[orderCounter] = Order(drugId, quantity, msg.sender, seller, false);
        emit OrderPlaced(orderCounter, drugId, quantity, msg.sender, seller);
    }

    function payOrder(uint256 orderId) public payable {
        Order storage order = orders[orderId];
        require(msg.value == drugPrices[order.drugId] * order.quantity, "Incorrect payment amount");
        require(order.buyer == msg.sender, "Only the buyer can pay for the order");
        payable(order.seller).transfer(msg.value);
        drugInventories[order.drugId] -= order.quantity;
        order.fulfillmentStatus = true;
    }

    function fulfillOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.seller == msg.sender, "Only the seller can fulfill the order");
        order.fulfillmentStatus = true;
        transferDrugOwnership(order.drugId, order.buyer);
    }

    function rateSeller(address seller, uint256 rating, string memory review) public {
        require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");
        sellerRatings[seller].push(rating);
        sellerReviews[seller].push(review);
    }
}
