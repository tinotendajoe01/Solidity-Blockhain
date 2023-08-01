/// @title Transporter Contract
/// @author Tinotenda Joe
/// @notice This contract manages the handling of packages in the supply chain
pragma solidity ^0.6.20;

import {Rawmaterial} from "./RawMaterial.sol";
import {Commodity} from "./Commodity.sol";
import {CommodityW_D} from "./CommodityW_D.sol";
import {CommodityD_C} from "./CommodityD_C.sol";

/// @title Model of a transporter's interaction with packages
contract Transporter {
    /// @notice Function to handle picking of packages
    /// @param _addr The address of the package origin
    /// @param transportertype The type of transporter (1- Supplier to Manufacturer, 2 - Manufacturer to Wholesaler, 3 - Wholesaler to Distributer, 4 - Distributer to Customer)
    /// @param cid The identifier for the commodity
    function handlePackage(address _addr, uint256 transportertype, address cid) public {
        if (transportertype == 1) {
            /// Supplier -> Manufacturer
            RawMaterial(_addr).pickPackage(msg.sender);
        } else if (transportertype == 2) {
            /// Manufacturer -> Wholesaler
            Commodity(_addr).pickCommodity(msg.sender);
        } else if (transportertype == 3) {
            /// Wholesaler to Distributor
            CommodityW_D(cid).pickWD(_addr, msg.sender);
        } else if (transportertype == 4) {
            /// Distributor to Customer
            CommodityD_C(cid).pickDC(_addr, msg.sender);
        }
    }
}
