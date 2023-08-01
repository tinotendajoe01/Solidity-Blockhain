// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.6;
/*
  Import the library from Openzeppelin for safe mathematical operations: 
  https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/math
*/

import "@openzeppelin/contracts/math/SafeMath.sol";
// Import your RawMaterial contract
import "./RawMaterial.sol";

/**
 * @title Supplier Contract for Supply Chain Protocol
 * @author Tinotenda Joe
 * @notice This contract serves as a decentralized platform for suppliers to manage their raw materials in a supply chain protocol.
 * @dev Following is just a simple explanation, consider implementing more complex logic in accordance with your needs.
 */
contract Supplier {
    // Use SafeMath library to perform safe arithmetic operations
    using SafeMath for uint256;

    // Mapping to keep track of supplier raw materials
    mapping(address => address[]) public supplierRawMaterials;

    event RawMaterialCreated(address indexed rawMaterialAddress, address indexed supplier);

    /**
     * @dev Constructor to set the initial storage
     */
    constructor() public {}

    /**
     * @notice Create a new raw material package
     * @param _description the description of the raw material
     * @param _quantity the quantity of the raw material
     * @param _transporterAddr the address of the transporter
     * @param _manufacturerAddr the address of the manufacturer
     * @dev Ensure the proper access controls and error handling (if needed), add events to capture the important state changes
     * TODO: Require checks can be added for inputs
     */
    function createRawMaterialPackage(
        bytes32 _description,
        uint256 _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) public {
        RawMaterial rawMaterial = new RawMaterial(
            msg.sender,
            address(bytes20(sha256(abi.encodePacked(msg.sender, now)))),
            _description,
            _quantity,
            _transporterAddr,
            _manufacturerAddr
        );

        supplierRawMaterials[msg.sender].push(address(rawMaterial));
        emit RawMaterialCreated(address(rawMaterial), msg.sender);
    }

    /**
     * @notice Get the number of packages of a supplier
     * @return the number of packages of the supplier
     * @dev This can be used to quickly check how many packages a supplier has
     * TODO: Consider returning more detailed information about each package
     */
    function getNoOfPackagesOfSupplier() public view returns (uint256) {
        return supplierRawMaterials[msg.sender].length;
    }

    /**
     * @notice Get all packages of a supplier
     * @return an array of addresses of the packages of the supplier
     * @dev Access controls can be added here to restrict this sensitive information
     * TODO: Access Controls using OpenZeppelin's AccessControl.sol
     * TODO: Consider returning more detailed information about each package
     */
    function getAllPackages() public view returns (address[] memory) {
        uint256 len = supplierRawMaterials[msg.sender].length;
        address[] memory packages = new address[](len);
        for (uint256 i = 0; i < len; i++) {
            packages[i] = supplierRawMaterials[msg.sender][i];
        }
        return packages;
    }

    // TODO: Add function removePackage which allows a supplier to remove a package from its list
    // function removePackage(address packageAddress) public {...}

    // TODO: Add function updatePackage which allows a supplier to update the details of a package (description, quantity, etc.)
    // function updatePackage(address packageAddress, bytes32 newDescription, uint newQuantity) public {...}
}
