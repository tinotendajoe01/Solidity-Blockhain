// SPDX-License-Identifier: SEE LICENSE IN LICENSE
/// @title Commodity Dispatch and Collection Contract
/// @author Tinotenda Joe
/// @notice This contract represents a dispatch and collection model for commodities
pragma solidity ^0.8.20;

import {Commodity} from "./Commodity.sol";

/// @title Model of commodity dispatch and collection
contract CommodityD_C {
    error UnAuthorised_Receiver();

    error Transporter_is_not_Authorised();

    /// @dev Storage for contract owner's address

    address Owner;

    /// @dev Enumeration of different package statuses
    enum packageStatus {
        atcreator,
        picked,
        delivered
    }

    /// Addresses for medAddr, sender, transporter, receiver
    address medAddr;
    address sender;
    address transporter;
    address receiver;

    /// @dev Store the status of package
    packageStatus status;

    /// @dev Constructor that initializes contract with initial parameters
    /// @param _address The medAddr
    /// @param Sender The sender's address
    /// @param Transporter The transporter's address
    /// @param Receiver The receiver's address
    constructor(address _address, address Sender, address Transporter, address Receiver) {
        Owner = Sender;
        medAddr = _address;
        sender = Sender;
        transporter = Transporter;
        receiver = Receiver;
        status = packageStatus(0);
    }

    /// @notice Called when the associated transporter initiates this function
    /// @param _address The commodity address
    /// @param transporterAddr The transporter's address
    function pickDC(address _address, address transporterAddr) public {
        if (transporter != transporterAddr) revert Transporter_is_not_Authorised();
        status = packageStatus(1);
        Commodity(_address).sendDtoC(receiver, sender);
    }

    /// @notice Called when the associated receiver initiates this function
    /// @param _address The commodity address
    /// @param Receiver The receiver's address
    function receiveDC(address _address, address Receiver) public {
        if (Receiver != receiver) revert UnAuthorised_Receiver();
        status = packageStatus(2);
        Commodity(_address).receivedDtoC(Receiver);
    }

    /// @notice Returns the current status of the package
    /// @return status The current status of the package
    function get_addressStatus() public view returns (uint256) {
        return uint256(status);
    }
}
