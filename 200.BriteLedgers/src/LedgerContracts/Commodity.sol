// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Transactions} from "./Transactions.sol";

/// @title Commodity
/// @notice This contract represents a commodity in a supply chain.
/// @dev It includes functions for managing the commodity's status and the parties involved in its shipment.
contract Commodity {
    error UnAuthorised_PickUp();
    error Only_Wholesaler_or_Distributor_Authorised();
    error Product_not_picked_up_yet();
    error Wholesaler_is_not_Associated();
    error Distributor_is_not_Associated();
    error Customer_is_not_Associated();
    error Package_at_Manufacturer();

    address Owner;

    /// @notice Represents the status of a commodity in the supply chain.
    enum commodityStatus {
        atManufacturer,
        pickedForW,
        pickedForD,
        deliveredAtW,
        deliveredAtD,
        pickedForC,
        deliveredAtC
    }

    bytes32 description; // A brief description of the commodity batch
    address[] rawMaterials; // The addresses of the raw materials used
    address[] transporters; // The addresses of the transporters involved in the shipment
    address manufacturer; // The address of the manufacturer
    address wholesaler; // The address of the wholesaler
    address distributor; // The address of the distributor
    address customer; // The address of the customer
    uint256 quantity; // The quantity of commodity in the batch
    commodityStatus status; // The current status of the commodity batch
    address txnContractAddress; // The address of the transaction contract used for payment

    /// @notice Emitted when there is an update to the shipment status.
    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint256 TransporterType,
        uint256 Status
    );

    /// @notice Creates a new commodity batch.
    /// @param _manufacturerAddr The address of the manufacturer creating the batch.
    /// @param _description A brief description of the batch.
    /// @param _rawAddr An array of addresses representing the raw materials used in the batch.
    /// @param _quantity The quantity of commodity in the batch.
    /// @param _transporterAddr An array of addresses representing the transporters involved in the shipment.
    /// @param _receiverAddr The address of the receiver of the batch.
    /// @param RcvrType An identifier for the type of receiver (1 for wholesaler, 2 for distributor).
    constructor(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint256 _quantity,
        address[] memory _transporterAddr,
        address _receiverAddr,
        uint256 RcvrType
    ) {
        Owner = _manufacturerAddr;
        manufacturer = _manufacturerAddr;
        description = _description;
        rawMaterials = _rawAddr;
        quantity = _quantity;
        transporters = _transporterAddr;
        if (RcvrType == 1) {
            wholesaler = _receiverAddr;
        } else if (RcvrType == 2) {
            distributor = _receiverAddr;
        }
        Transactions txnContract = new Transactions(_manufacturerAddr);
        txnContractAddress = address(txnContract);
    }

    /// @notice Returns information about the commodity batch.
    /// @return _manufacturerAddr The address of the manufacturer.
    /// @return _description A brief description of the commodity batch.
    /// @return _rawAddr An array of addresses representing the raw materials used in the batch.
    /// @return _quantity The quantity of commodity in the batch.
    /// @return _transporterAddr An array of addresses representing the transporters involved in the shipment.
    /// @return _distributor The address of the distributor.
    /// @return _customer The address of the customer.
    function getCommodityInfo()
        public
        view
        returns (
            address _manufacturerAddr,
            bytes32 _description,
            address[] memory _rawAddr,
            uint256 _quantity,
            address[] memory _transporterAddr,
            address _distributor,
            address _customer
        )
    {
        return (manufacturer, description, rawMaterials, quantity, transporters, distributor, customer);
    }

    /// @notice Returns the addresses of the wholesaler, distributor, and customer.
    /// @return WDP An array of 3 addresses representing the wholesaler, distributor, and customer.
    function getWDC() public view returns (address[3] memory WDP) {
        return ([wholesaler, distributor, customer]);
    }

    /// @notice Returns the current status of the commodity batch.
    /// @return A uint representing the current status of the commodity batch.
    function getBatchIDStatus() public view returns (uint256) {
        return uint256(status);
    }

    /// @notice Updates the status of the commodity batch when it is picked up by a transporter.
    /// @param _transporterAddr The address of the transporter picking up the commodity.
    function pickCommodity(address _transporterAddr) public {
        if (_transporterAddr != transporters[transporters.length - 1]) revert UnAuthorised_PickUp();
        if (status == commodityStatus(0)) revert Package_at_Manufacturer();

        if (wholesaler != address(0x0)) {
            status = commodityStatus(1);
            emit ShippmentUpdate(address(this), _transporterAddr, wholesaler, 1, 1);
        } else {
            status = commodityStatus(2);
            emit ShippmentUpdate(address(this), _transporterAddr, distributor, 1, 2);
        }
    }

    /// @notice Adds a transporter to the array of transporters involved in the shipment.
    /// @param _transporterAddr The address of the transporter to add.
    function updateTransporterArray(address _transporterAddr) public {
        transporters.push(_transporterAddr);
    }

    /// @notice Updates the status of the commodity batch when it is received by a wholesaler or distributor.
    /// @param _receiverAddr The address of the receiver (either wholesaler or distributor).
    /// @return A uint representing the new status of the commodity batch.
    function receivedCommodity(address _receiverAddr) public returns (uint256) {
        if (_receiverAddr != wholesaler || _receiverAddr != distributor) {
            revert Only_Wholesaler_or_Distributor_Authorised();
        }

        if (uint256(status) >= 1) revert Product_not_picked_up_yet();

        if (_receiverAddr == wholesaler && status == commodityStatus(1)) {
            status = commodityStatus(3);
            emit ShippmentUpdate(address(this), transporters[transporters.length - 1], wholesaler, 2, 3);
            return 1;
        } else if (_receiverAddr == distributor && status == commodityStatus(2)) {
            status = commodityStatus(4);
            emit ShippmentUpdate(address(this), transporters[transporters.length - 1], distributor, 3, 4);
            return 2;
        }
        return 0;
    }

    /// @notice Updates the distributor address and status of the commodity batch when it is sent from the wholesaler to the distributor.
    /// @param receiver The address of the distributor.
    /// @param sender The address of the wholesaler.
    function sendWtoD(address receiver, address sender) public {
        if (wholesaler != sender) revert Wholesaler_is_not_Associated();
        distributor = receiver;
        status = commodityStatus(2);
    }

    /// @notice Updates the status of the commodity batch when it is received by the distributor from the wholesaler.
    /// @param receiver The address of the distributor.
    function receivedWtoD(address receiver) public {
        if (distributor != receiver) revert Distributor_is_not_Associated();
        status = commodityStatus(4);
    }

    /// @notice Updates the customer address and status of the commodity batch when it is sent from the distributor to the customer.
    /// @param receiver The address of the customer.
    /// @param sender The address of the distributor.
    function sendDtoC(address receiver, address sender) public {
        if (distributor != sender) revert Distributor_is_not_Associated();
        customer = receiver;
        status = commodityStatus(5);
    }

    /// @notice Updates the status of the commodity batch when it is received by the customer from the distributor.
    /// @param receiver The address of the customer.
    function receivedDtoC(address receiver) public {
        if (customer != receiver) revert Customer_is_not_Associated();
        status = commodityStatus(6);
    }
}
