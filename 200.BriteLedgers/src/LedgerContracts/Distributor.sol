/// @title Commodity Distributor Contract
/// @author Tinotenda Joe
/// @notice This contract manages commodities received by distributor and their transfer
pragma solidity ^0.6.6;

import {CommodityW_D} from "./CommodityW_D.sol";
import {Commodity} from "./Commodity.sol";
import {CommodityD_C} from "./CommodityD_C.sol";

/// @title Model for distributor's interaction with commodities
contract Distributor {
    /// @notice Track commodities at distributor's address
    /// @dev Mapping of distributor's address to array of commodity addresses
    mapping(address => address[]) public CommoditysAtDistributor;

    /// @notice Track transfer of commodities from distributor to customer
    /// @dev Mapping of distributor's address to array of CommodityD_C contract addresses
    mapping(address => address[]) public CommodityDtoC;

    /// @notice Track individual commodity transfer contracts
    /// @dev Mapping of commodity address to CommodityD_C contract address
    mapping(address => address) public CommodityDtoCTxContract;

    /// @notice Function to be called when a commodity is received at the distributor
    /// @param _address The address of the commodity
    /// @param cid The identifier for the commodity
    function commodityRecievedAtDistributor(address _address, address cid) public {
        uint256 rtype = Commodity(_address).receivedCommodity(msg.sender);
        if (rtype == 2) {
            CommoditysAtDistributor[msg.sender].push(_address);
            if (Commodity(_address).getWDC()[0] != address(0)) {
                CommodityW_D(cid).receiveWD(_address, msg.sender);
            }
        }
    }

    /// @notice Function to transfer commodity from distributor to customer
    /// @param _address The address of the commodity
    /// @param transporter The transporter's address
    /// @param receiver The receiver or customer's address
    function transferCommodityDtoC(address _address, address transporter, address receiver) public {
        CommodityD_C dp = new CommodityD_C(
            _address,
            msg.sender,
            transporter,
            receiver
        );
        CommodityDtoC[msg.sender].push(address(dp));
        CommodityDtoCTxContract[_address] = address(dp);
    }
}
