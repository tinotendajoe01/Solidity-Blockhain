// SPDX-License-Identifier: SEE LICENSE IN LICENSE
/// @title Commodity Consumer Contract
/// @author Tinotenda Joe
/// @notice This contract manages the commodities received by Consumers and track of their sales status
pragma solidity ^0.8.20;

import {CommodityD_C} from "./CommodityD_C.sol";

/// @title Model of Consumer's interaction with commodity
contract FinalCunsumer {
    /// @notice Tracks the commodities at the Consumer
    /// @dev mapping of Consumer address to array of addresses
    mapping(address => address[]) public CommodityBatchAtConsumer;

    /// @notice Tracks the sale status of commodities
    /// @dev mapping of address to sale status
    mapping(address => salestatus) public sale;

    /// @dev Enumeration for possible statuses of the sale
    enum salestatus {
        notfound,
        atConsumer,
        sold,
        expired,
        damaged
    }

    /// @notice Event to be emitted when commodity status changes
    /// @dev Event includes the commodity address, Consumer's address and status
    event CommodityStatus(address _address, address indexed Consumer, uint256 status);

    /// @notice Function to be called when the Consumer receives a commodity
    /// @param _address The address of the commodity
    /// @param cid The identifier for the commodity
    function CommodityRecievedAtConsumer(address _address, address cid) public {
        CommodityD_C(cid).receiveDC(_address, msg.sender);
        CommodityBatchAtConsumer[msg.sender].push(_address);
        sale[_address] = salestatus(1);
    }

    /// @notice Function to update the sale status of a commodity
    /// @param _address The address of the commodity
    /// @param Status The status of the sale
    function updateSaleStatus(address _address, uint256 Status) public {
        sale[_address] = salestatus(Status);
        emit CommodityStatus(_address, msg.sender, Status);
    }

    /// @notice Function to get sales information for a given commodity
    /// @param _address The address of the commodity
    /// @return Status The status of the sale
    function salesInfo(address _address) public view returns (uint256 Status) {
        return uint256(sale[_address]);
    }
}
