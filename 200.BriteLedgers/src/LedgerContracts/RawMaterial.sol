// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Transactions} from "./Transactions.sol";

/// @title RawMaterial Supply Chain Protocol
/// @author Tinotenda Joe
/// @notice This contract is part of a supply chain protocol that allows managing the logistics of raw materials
contract RawMaterial {
    address Owner;

    /// @notice Possible statuses of a package
    enum packageStatus {
        atCreator,
        picked,
        delivered
    }

    /// @notice Reports a status update for the shipment
    event ShippmentUpdate(
        address indexed ProductID,
        address indexed Transporter,
        address indexed Manufacturer,
        uint256 TransporterType,
        uint256 Status
    );

    address productid;
    bytes32 description;
    uint256 quantity;
    address transporter;
    address manufacturer;
    address supplier;
    packageStatus status;
    bytes32 packageReceiverDescription;
    address txnContractAddress;

    /// @notice Construct a new RawMaterial contract
    /// @param _creatorAddr the address of the creator
    /// @param _productid the ID of the product
    /// @param _description the description of the product
    /// @param _quantity the quantity of the product
    /// @param _transporterAddr the address of the transporter
    /// @param _manufacturerAddr the address of the manufacturer
    constructor(
        address _creatorAddr,
        address _productid,
        bytes32 _description,
        uint256 _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) {
        Owner = _creatorAddr;
        productid = _productid;
        description = _description;
        quantity = _quantity;
        transporter = _transporterAddr;
        manufacturer = _manufacturerAddr;
        supplier = _creatorAddr;
        status = packageStatus(0);
        Transactions txnContract = new Transactions(_manufacturerAddr);
        txnContractAddress = address(txnContract);
    }

    /// @notice Returns all the supplied raw materials
    /// @return productid, description, quantity, supplier, transporter, manufacturer, txnContractAddress
    function getSuppliedRawMaterials()
        public
        view
        returns (address, bytes32, uint256, address, address, address, address)
    {
        return (productid, description, quantity, supplier, transporter, manufacturer, txnContractAddress);
    }

    /// @notice Returns the status of the raw material
    /// @return status of the raw material
    function getRawMaterialStatus() public view returns (uint256) {
        return uint256(status);
    }

    /// @notice Pick a package from the supplier
    /// @param _transporterAddr the address of the transporter
    function pickPackage(address _transporterAddr) public {
        require(_transporterAddr == transporter);
        require(status == packageStatus(0));
        status = packageStatus(1);
        emit ShippmentUpdate(productid, transporter, manufacturer, 1, 1);
    }

    /// @notice Receive a package at the manufacturer
    /// @param _manufacturerAddr the address of the manufacturer
    function receivedPackage(address _manufacturerAddr) public {
        require(_manufacturerAddr == manufacturer);
        require(status == packageStatus(1));
        status = packageStatus(2);
        emit ShippmentUpdate(productid, transporter, manufacturer, 1, 2);
    }
}
