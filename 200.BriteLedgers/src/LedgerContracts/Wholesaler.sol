// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./CommodityW_D.sol";
import {Commodity} from "./Commodity.sol";

/// @title Wholesaler Contract for Supply Chain Protocol
/// @author Your Name
/// @notice This contract manages the transfer of commodities from a wholesaler to a distributor.
/// @dev This contract interacts with the Commodity and CommodityW_D contracts.
contract Wholesaler {
    /// @notice Maps a wholesaler's address to an array of commodity addresses that the wholesaler has received.
    mapping(address => address[]) public CommoditiesAtWholesaler;
    /// @notice Maps a wholesaler's address to an array of CommodityW_D contract addresses that the wholesaler has initiated.
    mapping(address => address[]) public CommodityWtoD;
    /// @notice Maps a commodity's address to the CommodityW_D contract address that manages its transfer from a wholesaler to a distributor.
    mapping(address => address) public CommodityWtoDTxContract;

    /// @notice Marks a commodity as received by the wholesaler.
    /// @dev Calls the receivedCommodity function of the Commodity contract.
    /// @param _address The address of the Commodity contract.
    function commodityRecievedAtWholesaler(address _address) public {
        uint256 rtype = Commodity(_address).receivedCommodity(msg.sender);
        if (rtype == 1) {
            CommoditiesAtWholesaler[msg.sender].push(_address);
        }
    }

    /// @notice Initiates the transfer of a commodity from the wholesaler to a distributor.
    /// @dev Creates a new CommodityW_D contract for the transfer.
    /// @param _address The address of the Commodity contract.
    /// @param transporter The address of the transporter.
    /// @param receiver The address of the distributor.
    function transferCommodityWtoD(address _address, address transporter, address receiver) public {
        CommodityW_D wd = new CommodityW_D(
            _address,
            msg.sender,
            transporter,
            receiver
        );
        CommodityWtoD[msg.sender].push(address(wd));
        CommodityWtoDTxContract[_address] = address(wd);
    }
}
