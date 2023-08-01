// SPDX-License-Identifier: SEE LICENSE IN LICENSE
/// @title Manufacturer Contract
/// @author Anonymous
/// @notice This contract manages the receipt and creation of commodities by a manufacturer
pragma solidity ^0.8.20;

import {RawMaterial} from "./RawMaterial.sol";
import {Commodity} from "./Commodity.sol";

/// @title Manufacturer's interaction with raw materials and commodities
contract Manufacturer {
    /// @notice Track the raw materials owned by manufacturers
    /// @dev Mapping of manufacturer's address to array of RawMaterial contract addresses
    mapping(address => address[]) public manufacturerRawMaterials;

    /// @notice Track the commodities produced by manufacturers
    /// @dev Mapping of manufacturer's address to array of Commodity contract addresses
    mapping(address => address[]) public manufacturerCommodities;

    /// @notice Function called when a manufacturer receives a package of raw materials
    /// @param _addr The address of the RawMaterial contract
    /// @param _manufacturerAddress The address of the manufacturer
    function manufacturerReceivedPackage(address _addr, address _manufacturerAddress) public {
        RawMaterial(_addr).receivedPackage(_manufacturerAddress);
        manufacturerRawMaterials[_manufacturerAddress].push(_addr);
    }

    /// @notice Function called when a manufacturer creates a new commodity
    /// @param _manufacturerAddr The address of the manufacturer
    /// @param _description The description of the commodity
    /// @param _rawAddr The array of addresses of raw materials used for the commodity
    /// @param _quantity The quantity of the commodity
    /// @param _transporterAddr The array of addresses of transporters for the commodity
    /// @param _recieverAddr The address of the receiver of the commodity
    /// @param RcvrType The type of the receiver (encoded as a uint256)
    function manufacturerCreatesCommodity(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint256 _quantity,
        address[] memory _transporterAddr,
        address _recieverAddr,
        uint256 RcvrType
    ) public {
        Commodity _commodity = new Commodity(
            _manufacturerAddr,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _recieverAddr,
            RcvrType
        );
        manufacturerCommodities[_manufacturerAddr].push(address(_commodity));
    }
}
