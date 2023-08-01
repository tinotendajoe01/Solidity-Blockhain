# RawMaterial
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/cf463adb86eb681dea89cb8178867ce0ef041f33/src/Upgrades/RawMaterials.u.sol)

**Author:**
Tinotenda Joe

This contract is part of a supply chain protocol that allows managing the logistics of raw materials.

*TODO: Implement Access Control using OpenZeppelin's AccessControl library. For example:*

*`import "@openzeppelin/contracts/access/AccessControl.sol";`*

*`contract RawMaterial is AccessControl {...}`*

*TODO: Add more events to capture important state changes. For example:*

*`event PackageStatusUpdated(address indexed ProductID, uint256 newStatus);`*

*TODO: Include error messages in your revert statements. For example:*

*`require(_transporterAddr == transporter, "Only the assigned transporter can pick the package");`*

*TODO: Consider adding a function to change the transporter or manufacturer. For example:*

*`function setTransporter(address newTransporter) public {...}`*

*`function setManufacturer(address newManufacturer) public {...}`*

*TODO: Consider adding a function to update the quantity of the raw material. For example:*

*`function updateQuantity(uint256 newQuantity) public {...}`*

*TODO: Consider how your contract will interact with external systems. For example:*

*`function makePayment(address payee, uint256 amount) public {...}`*

*TODO: Make your contract upgradeable using OpenZeppelin's upgradeable contracts library. For example:*

*`import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";`*

*`contract RawMaterial is Initializable {...}`*

*TODO: Write comprehensive tests for your contract.*

*TODO: Review your contract for potential security issues. Consider having it audited by a professional.*


