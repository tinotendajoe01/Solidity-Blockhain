// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

/// @title Supplier Contract for Supply Chain Protocol
/// @author Tinotenda Joe
/// @notice This contract serves as a decentralized platform for suppliers to manage their raw materials in a supply chain protocol.
/// @dev This contract is intended to be upgraded and expanded with additional features and functionality.
/// @dev Developers should consider the following when upgrading this contract:
/// @dev - Implementing Access Control using OpenZeppelin's AccessControl library for role-based access control.
/// @dev - Adding more events to capture important state changes, such as when a raw material package is created, updated, or removed.
/// @dev - Including error messages in revert statements to provide more context when transactions fail.
/// @dev - Adding functions to update and remove raw material packages.
/// @dev - Considering how this contract will interact with external systems, such as payment gateways or other smart contracts.
/// @dev - Making this contract upgradeable using OpenZeppelin's upgradeable contracts library.
/// @dev - Writing comprehensive tests for this contract to ensure all functionality works as expected.
/// @dev - Reviewing this contract for potential security issues and consider having it audited by a professional.
/// @dev - Implementing a decentralized identity protocol to verify the identity and reputation of customers and partners.
/// @dev - Implementing an encrypted messaging system to securely share information with customers and partners.
/// @dev - Implementing IoT data providers to track the performance of products.
/// @dev - Implementing a token-based financing system to access financing from a pool of lenders.
/// @dev - Implementing a decentralized marketplace to interact with buyers directly and access more accurate market information.
/// @dev - Streamlining regulatory processes and improving compliance by automating the submission of regulatory reports and providing real-time access to supplier data.
/// @dev - Providing incentives for compliance, such as access to financing, preferential treatment in the marketplace, or other benefits.
/// @dev - Onboarding suppliers onto the platform by creating a user account and registering their products and services.
/// @dev - Granting regulatory staff access to supplier information through a secure and encrypted platform that provides real-time access to supplier data.
/// @dev - Automating the enforcement of regulations and providing a transparent and auditable record of compliance.
/// @dev - Creating a set of smart contracts that specify the rules and regulations that suppliers must comply with, as well as the penalties for non-compliance.

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @title Supplier Contract for Supply Chain Protocol
/// @author Tinotenda Joe
/// @notice This contract serves as a decentralized platform for suppliers to manage their raw materials in a supply chain protocol.
/// @dev This contract is intended to be upgraded and expanded with additional features and functionality.
contract Supplier is AccessControl, Initializable {
    // Define roles for access control
    bytes32 public constant SUPPLIER_ROLE = keccak256("SUPPLIER_ROLE");
    bytes32 public constant REGULATOR_ROLE = keccak256("REGULATOR_ROLE");

    // Define events
    event RawMaterialCreated(address indexed rawMaterialAddress, address indexed supplier);
    event RawMaterialUpdated(address indexed rawMaterialAddress, address indexed supplier);
    event RawMaterialRemoved(address indexed rawMaterialAddress, address indexed supplier);

    // Define state variables
    mapping(address => RawMaterial) public rawMaterials;

    struct RawMaterial {
        bytes32 description;
        uint256 quantity;
    }

    // Define functions
    function createRawMaterial(address rawMaterialAddress, bytes32 description, uint256 quantity) public {
        require(hasRole(SUPPLIER_ROLE, msg.sender), "Caller is not a supplier");
        require(quantity > 0, "Quantity must be greater than zero");

        rawMaterials[rawMaterialAddress] = RawMaterial(description, quantity);

        emit RawMaterialCreated(rawMaterialAddress, msg.sender);
    }

    function updateRawMaterial(address rawMaterialAddress, bytes32 newDescription, uint256 newQuantity) public {
        require(hasRole(SUPPLIER_ROLE, msg.sender), "Caller is not a supplier");
        require(newQuantity > 0, "Quantity must be greater than zero");

        RawMaterial storage rawMaterial = rawMaterials[rawMaterialAddress];
        rawMaterial.description = newDescription;
        rawMaterial.quantity = newQuantity;

        emit RawMaterialUpdated(rawMaterialAddress, msg.sender);
    }

    function removeRawMaterial(address rawMaterialAddress) public {
        require(hasRole(SUPPLIER_ROLE, msg.sender), "Caller is not a supplier");

        delete rawMaterials[rawMaterialAddress];

        emit RawMaterialRemoved(rawMaterialAddress, msg.sender);
    }

    // Define upgradeable initializer
    function initialize() public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
}
