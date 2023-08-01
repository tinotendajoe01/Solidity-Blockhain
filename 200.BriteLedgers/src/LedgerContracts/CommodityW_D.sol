/// @title Commodity Shipping Contract
/// @author Tinotenda Joe
/// @notice This contract represents a shipping model for commodities
pragma solidity ^0.8.20;

import {Commodity} from "./Commodity.sol";

contract CommodityW_D {
    /// @dev Thrown when an unauthorized receiver's account is used
    error UnAUthorised_Receivers_Account();

    /// @dev Thrown when an unauthorized shipper's account is used
    error UnAUthorised_Shippers_Account();

    /// @dev Store the contract owner's address
    address Owner;

    /// @dev Enumeration of various package statuses
    enum packageStatus {
        atcreator,
        picked,
        delivered
    }

    /// Addresses for commodityId, sender, transporter, receiver
    address commodityId;
    address sender;
    address transporter;
    address receiver;

    /// @dev Stores the current package status
    packageStatus status;

    /// @dev Setup the contract with initial details
    /// @param _address The commodity address
    /// @param Sender The sender's address
    /// @param Transporter The transporter's address
    /// @param Receiver The receiver's address
    constructor(address _address, address Sender, address Transporter, address Receiver) {
        Owner = Sender;
        commodityId = _address;
        sender = Sender;
        transporter = Transporter;
        receiver = Receiver;
        status = packageStatus(0);
    }

    /// @notice Called when the transporter picks the package
    /// @param _address The commodity address
    /// @param _transporter The transporter's address
    function pickWD(address _address, address _transporter) public {
        if (transporter != _transporter) revert UnAUthorised_Shippers_Account();
        status = packageStatus(1);
        Commodity(_address).sendWtoD(receiver, sender);
    }

    /// @notice Called when the receiver receives the package
    /// @param _address The commodity address
    /// @param Receiver The receiver's address
    function receiveWD(address _address, address Receiver) public {
        require(Receiver != receiver, "Unauthorized receiver's account");
        status = packageStatus(2);
        Commodity(_address).receivedWtoD(Receiver);
    }

    /// @notice Returns the current status of the package
    /// @return status The current status of the package
    function getBatchIDStatus() public view returns (uint256) {
        return uint256(status);
    }
}
