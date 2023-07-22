// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.20;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title SupplyChain
 * @dev Implements a basic supply chain management system
 * @author Tinotenda Joe
 *
 * Entities involved in the supply chain (Suppliers, Regulators, Consumers) are represented by Ethereum addresses.
 * Drugs are represented by a unique identifier and include information such as name, description, manufacturer, current owner, ownership chain, and authenticity status.
 * Orders represent a transaction of a drug from a supplier to a consumer and include information such as drug id, buyer, seller, and fulfillment status.
 *
 * This contract uses the OpenZeppelin AccessControl contract for role-based access control.
 */

contract SupplyChainAccount is BaseAccount, TokenCallbackHandler, UUPSUpgradeable, Initializable {
    using ECDSA for bytes32;

    bytes32 public constant SUPPLIER_ROLE = keccak256("SUPPLIER");
    bytes32 public constant REGULATOR_ROLE = keccak256("REGULATOR");
    bytes32 public constant CONSUMER_ROLE = keccak256("CONSUMER");
    Paymaster public paymaster;

    /// @notice Emitted when a new entity is created

    event NewEntityCreated(address indexed entityAddress, string role);
    /// @notice Emitted when a new order is created
    event NewOrderCreated(string orderId, string drugId);
    /// @notice Emitted when an order is fulfilled
    event OrderFulfilled(string orderId);
    /// @notice Emitted when a drug is transferred from one entity to another in the supply chain
    event DrugTransferred(string drugId, address from, address to);
    /// @notice Emitted when a drug is verified by a regulator
    event DrugVerified(string drugId, bool authenticity);
    /// @notice Emitted when a drug is invalidated by a regulator
    event DrugInvalidated(string drugId);

    // Entities in supply chain
    struct Supplier {
        address id;
        string name;
    }

    struct Regulator {
        address id;
        string name;
    }

    struct Consumer {
        address id;
        string name;
    }

    // Map identifiers to struct instances
    mapping(address => Supplier) public suppliers;
    mapping(address => Regulator) public regulators;
    mapping(address => Consumer) public consumers;

    // Drug structure
    struct Drug {
        string name;
        string description;
        address manufacturer;
        address currentOwner;
        address[] ownersChain;
        bool isAuthentic;
    }

    // The drugs mapping is now indexed by drug id to Drug
    mapping(string => Drug) public drugs;

    // Struct for Order
    struct Order {
        string drugId;
        address buyer;
        address seller;
        bool isFulfilled;
    }

    // Orders mapping
    mapping(string => Order) public orders;

    /**
     * @dev Creates a new Supplier in the system and grants the SUPPLIER_ROLE
     * @notice Only callable by an account with ADMIN role
     * @param _id The address of the supplier
     * @param _name The name of the supplier
     */

    function createSupplier(address _id, string memory _name) public {
        grantRole(SUPPLIER_ROLE, _id);
        suppliers[_id] = Supplier(_id, _name);
        emit NewEntityCreated(_id, "SUPPLIER");
    }

    /**
     * @dev Creates a new Regulator in the system and grants the REGULATOR_ROLE
     * @notice Only callable by an account with ADMIN role
     * @param _id The address of the regulator
     * @param _name The name of the regulator
     */
    function createRegulator(address _id, string memory _name) public {
        grantRole(REGULATOR_ROLE, _id);
        regulators[_id] = Regulator(_id, _name);
        emit NewEntityCreated(_id, "REGULATOR");
    }

    /**
     * @dev Creates a new Consumer in the system and grants the CONSUMER_ROLE
     * @notice Only callable by an account with ADMIN role
     * @param _id The address of the consumer
     * @param _name The name of the consumer
     */
    function createConsumer(address _id, string memory _name) public {
        grantRole(CONSUMER_ROLE, _id);
        consumers[_id] = Consumer(_id, _name);
        emit NewEntityCreated(_id, "CONSUMER");
    }

    /**
     * @dev Creates a new Order in the system
     * @notice Only callable if the drug is authentic
     * @param _orderId The unique identifier for the order
     * @param _drugId The identifier of the drug being ordered
     * @param _buyer The address of the buyer
     * @param _seller The address of the seller
     */
    function createOrder(string memory _orderId, string memory _drugId, address _buyer, address _seller) public {
        require(drugs[_drugId].isAuthentic, "Drug must be valid.");
        orders[_orderId] = Order(_drugId, _buyer, _seller, false);
        emit NewOrderCreated(_orderId, _drugId);
    }
    /**
     * @dev Fulfills an Order in the system
     * @notice Only callable by a supplier, and if he is the seller for that order and the owner of the drug
     * @param _orderId The unique identifier for the order
     */

    function fulfillOrder(string memory _orderId) public {
        require(hasRole(SUPPLIER_ROLE, msg.sender), "Caller does not have supplier role.");
        require(orders[_orderId].seller == msg.sender, "Caller is not the seller.");
        require(drugs[orders[_orderId].drugId].currentOwner == msg.sender, "Caller does not own the drug.");
        transferDrug(orders[_orderId].drugId, orders[_orderId].buyer);
        orders[_orderId].isFulfilled = true;
        emit OrderFulfilled(_orderId);
    }

    /**
     * @dev Creates a new drug in the system
     * @notice Only a supplier can call this function
     * @param _id The unique identifier for the drug
     * @param _name The name of the drug
     * @param _description The description of the drug
     * @param _manufacturer The address of the manufacturer of the drug
     * @dev Override the existing _pre function to include a check for sufficient balance in the Paymaster
     */
    function createDrug(string memory _id, string memory _name, string memory _description, address _manufacturer)
        public
        onlyRole(SUPPLIER_ROLE)
        whenNotPaused
    {
        uint256 gasCost = 21000; //To Replace with actual gas cost
        paymaster.useBalanceFromContract(msg.sender, tx.gasprice * gasCost);

        require(hasRole(SUPPLIER_ROLE, msg.sender), "Caller does not have supplier role.");
        require(
            keccak256(abi.encodePacked(drugs[_id].name)) == keccak256(abi.encodePacked("")),
            "Drug with this ID already exists."
        );
        drugs[_id] = Drug(_name, _description, _manufacturer, _manufacturer, new address[](0), true);
        drugs[_id].ownersChain.push(_manufacturer);
    }

    /**
     * @dev Transfers ownership of a drug
     * @notice Only callable by the current owner of the drug
     * @param _id The unique identifier for the drug
     * @param _receiver The address of the new owner
     */

    function transferDrug(string memory _id, address _receiver) public {
        require(msg.sender == drugs[_id].currentOwner, "Only the current owner can transfer a drug.");
        drugs[_id].currentOwner = _receiver;
        drugs[_id].ownersChain.push(_receiver);
        emit DrugTransferred(_id, msg.sender, _receiver);
    }

    /**
     * @dev Verifies authenticity of a drug
     * @notice Only callable by a regulator
     * @param _id The unique identifier for the drug
     * @param _authenticity The new authenticity status
     */
    function verifyDrug(string memory _id, bool _authenticity) public {
        require(hasRole(REGULATOR_ROLE, msg.sender), "Caller does not have regulator role.");
        drugs[_id].isAuthentic = _authenticity;
        emit DrugVerified(_id, _authenticity);
    }

    /**
     * @dev Invalidates a drug
     * @notice Only callable by a regulator, and if the drug is currently authentic
     * @param _id The unique identifier for the drug
     */

    function invalidateDrug(string memory _id) public {
        require(hasRole(REGULATOR_ROLE, msg.sender), "Caller does not have regulator role.");
        require(drugs[_id].isAuthentic, "Drug is already invalid.");
        drugs[_id].isAuthentic = false;
        emit DrugInvalidated(_id);
    }
    /**
     * @dev Set the Paymaster for this contract
     * @param _paymaster the address of the Paymaster contract
     */

    function setPaymaster(address _paymaster) public onlyRole(DEFAULT_ADMIN_ROLE) {
        paymaster = Paymaster(_paymaster);
    }

    /// @notice Fetches the ownership chain of a drug
    function getOwnershipChain(string memory _id) public view returns (address[] memory) {
        return drugs[_id].ownersChain;
    }

    /// @notice Fetches the current owner of a drug
    function getCurrentOwner(string memory _id) public view returns (address) {
        return drugs[_id].currentOwner;
    }

    /**
     * @dev Fetches the origin (manufacturer) of a drug
     * @notice Assumes the manufacturer is the first owner in the ownership chain
     * @param _id The unique identifier for the drug
     */
    function getOrigin(string memory _id) public view returns (address) {
        // Assuming manufacturer is the first owner in ownersChain
        return drugs[_id].ownersChain[0];
    }
}
