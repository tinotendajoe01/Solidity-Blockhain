// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
/// @title RawMaterial Supply Chain Protocol
/// @author Tinotenda Joe
/// @notice This contract is part of a supply chain protocol that allows managing the logistics of raw materials.
/// @dev TODO: Implement Access Control using OpenZeppelin's AccessControl library. For example:
/// @dev     `import "@openzeppelin/contracts/access/AccessControl.sol";`
/// @dev     `contract RawMaterial is AccessControl {...}`
/// @dev TODO: Add more events to capture important state changes. For example:
/// @dev     `event PackageStatusUpdated(address indexed ProductID, uint256 newStatus);`
/// @dev TODO: Include error messages in your revert statements. For example:
/// @dev     `require(_transporterAddr == transporter, "Only the assigned transporter can pick the package");`
/// @dev TODO: Consider adding a function to change the transporter or manufacturer. For example:
/// @dev     `function setTransporter(address newTransporter) public {...}`
/// @dev     `function setManufacturer(address newManufacturer) public {...}`
/// @dev TODO: Consider adding a function to update the quantity of the raw material. For example:
/// @dev     `function updateQuantity(uint256 newQuantity) public {...}`
/// @dev TODO: Consider how your contract will interact with external systems. For example:
/// @dev     `function makePayment(address payee, uint256 amount) public {...}`
/// @dev TODO: Make your contract upgradeable using OpenZeppelin's upgradeable contracts library. For example:
/// @dev     `import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";`
/// @dev     `contract RawMaterial is Initializable {...}`
/// @dev TODO: Write comprehensive tests for your contract.
/// @dev TODO: Review your contract for potential security issues. Consider having it audited by a professional.

contract RawMaterial {
// ...
}
