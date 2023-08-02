// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {RawMaterial} from "./RawMaterial.sol";
import {Supplier} from "./Supplier.sol";
import {Transporter} from "./Transporter.sol";
import {Commodity} from "./Commodity.sol";
import {Manufacturer} from "./Manufacturer.sol";
import {CommodityW_D} from "./CommodityW_D.sol";
import {Wholesaler} from "./Wholesaler.sol";
import {CommodityD_C} from "./CommodityD_C.sol";
import {Distributor} from "./Distributor.sol";
import {FinalConsumer} from "./FinalConsumer.sol";
/**
 * @title BriteLedgersV1
 * @author  Tinotenda Joe
 * @dev This contract  models multiple roles within the supply chain: Supplier, Transporter, Manufacturer, Wholesaler, Distributor, and Consumer. Each role is tied to a unique address and has role-specific functions.
 *
 * @notice The contract's core is a 'Tokenized Shared Ledger' that logs every transaction and interaction in the supply chain. This ledger provides an immutable, transparent, and verifiable record of the entire process, from the supplier to the consumer.
 *
 * @dev The contract integrates the Industrial Internet of Things (IIOT) for real-time data monitoring and recording at various stages of the supply chain. .
 *
 * @notice The contract can connect with existing off-chain, legacy supply chain systems. It incorporates both on and off-chain security measures to protect sensitive data while maintaining its transparent and traceable nature .
 */

contract BriteLedgersV1 is Supplier, Transporter, Manufacturer, Wholesaler, Distributor, FinalConsumer {
    /**
     * @notice Owner of the contract
     */

    address public Owner;

    constructor() {
        Owner = msg.sender;
    }
    /**
     * @notice Ensures that only the owner can call the function
     */

    modifier onlyOwner() {
        require(Owner == msg.sender);
        _;
    }
    /**
     * @notice Validates handed-over users
     */

    modifier checkUser(address addr) {
        require(addr == msg.sender);
        _;
    }

    /**
     * @dev Enum which defines the different actors in the system
     */

    enum roles {
        noRole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributor,
        consumer
    }

    //////////////// Events ////////////////////
    /**
     * @notice Events to make the smart contract interaction transparent
     */
    event UserRegister(address indexed _address, bytes32 name);
    event buyEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);
    event respondEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);
    event sendEvent(address seller, address buyer, address packageAddr, bytes32 signature, uint256 indexed now);
    event receivedEvent(address buyer, address seller, address packageAddr, bytes32 signature, uint256 indexed now);

    /////////////// Users (Only Owner Executable) //////////////////////
    /**
     * @notice Struct to define a user
     */
    struct userData {
        bytes32 name;
        string[] userLoc;
        roles role;
        address userAddr;
    }
    /**
     * @notice Mapping from address to userData
     */

    mapping(address => userData) public userInfo;
    /**
     * @dev Registers a user with a given name, location, role, and address.
     * Can only be executed by the owner of the contract.
     * Emits a UserRegister event after successful registration.
     * @param name user's name
     * @param loc user's location
     * @param role user's role
     * @param _userAddr user's address
     */

    function registerUser(bytes32 name, string[] memory loc, uint256 role, address _userAddr) external onlyOwner {
        userInfo[_userAddr].name = name;
        userInfo[_userAddr].userLoc = loc;
        userInfo[_userAddr].role = roles(role);
        userInfo[_userAddr].userAddr = _userAddr;

        emit UserRegister(_userAddr, name);
    }
    /**
     * @dev Allows the owner to change the role of a user.
     * @param _role The new role of the user.
     * @param _addr The address of the user.
     * @return Status of the operation.
     */

    function changeUserRole(uint256 _role, address _addr) external onlyOwner returns (string memory) {
        userInfo[_addr].role = roles(_role);
        return "Role Updated!";
    }
    /**
     * @dev Allows the owner to get the user information of the given address.
     * @param _address Address of the user.
     * @return User information.
     */

    function getUserInfo(address _address) external view onlyOwner returns (userData memory) {
        return userInfo[_address];
    }

    /////////////// Supplier //////////////////////

    /// @notice Creates a package of raw material
    /// @dev Can only be executed by a supplier
    /// @param _description Description of the raw material
    /// @param _quantity Quantity of the raw material
    /// @param _transporterAddr Address of the transporter
    /// @param _manufacturerAddr Address of the manufacturer
    function supplierCreatesRawPackage(
        bytes32 _description,
        uint256 _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) external {
        require(userInfo[msg.sender].role == roles.supplier, "Role=>Supplier can use this function");

        createRawMaterialPackage(_description, _quantity, _transporterAddr, _manufacturerAddr);
    }

    /// @notice Returns the count of packages created by the supplier
    /// @dev Can only be executed by a supplier
    /// @return The number of packages created by the supplier
    function supplierGetPackageCount() external view returns (uint256) {
        require(userInfo[msg.sender].role == roles.supplier, "Role=>Supplier can use this function");

        return getNoOfPackagesOfSupplier();
    }

    /// @notice Returns the addresses of all packages created by the supplier
    /// @dev Can only be executed by a supplier
    /// @return An array of addresses of all packages created by the supplier
    function supplierGetRawMaterialAddresses() external view returns (address[] memory) {
        address[] memory ret = getAllPackages();
        return ret;
    }

    ///////////////  Transporter ///////////////

    /// @notice Handles the package by the transporter
    /// @dev Can only be executed by a transporter
    /// @param _address The address of the package
    /// @param transporterType The type of the transporter
    /// @param cid The id of the commodity
    function transporterHandlePackage(address _address, uint256 transporterType, address cid) external {
        require(userInfo[msg.sender].role == roles.transporter, "Only Transporter can call this function");
        require(transporterType > 0, "Transporter Type is incorrect");

        handlePackage(_address, transporterType, cid);
    }

    ///////////////  Manufacturer ///////////////

    /// @notice Handles the receipt of raw materials by the manufacturer
    /// @dev Can only be executed by a manufacturer
    /// @param _addr The address of the raw material package
    function manufacturerReceivedRawMaterials(address _addr) external {
        require(userInfo[msg.sender].role == roles.manufacturer, "Only Manufacturer can access this function");
        manufacturerReceivedPackage(_addr, msg.sender);
    }

    /// @notice Creates a new commodity by the manufacturer
    /// @dev Can only be executed by a manufacturer
    /// @param _description The description of the commodity
    /// @param _rawAddr The addresses of the raw materials
    /// @param _quantity The quantity of the commodity
    /// @param _transporterAddr The addresses of the transporters
    /// @param _receiverAddr The address of the receiver
    /// @param RcvrType The type of the receiver
    /// @return A message indicating the commodity has been created
    function manufacturerCreatesNewCommodity(
        bytes32 _description,
        address[] memory _rawAddr,
        uint256 _quantity,
        address[] memory _transporterAddr,
        address _receiverAddr,
        uint256 RcvrType
    ) external returns (string memory) {
        require(userInfo[msg.sender].role == roles.manufacturer, "Only Manufacturer can create Commodity");
        require(RcvrType != 0, "Reciever Type should be defined");

        manufacturerCreatesCommodity(
            msg.sender, _description, _rawAddr, _quantity, _transporterAddr, _receiverAddr, RcvrType
        );

        return "Commodity created!";
    }

    ///////////////  Wholesaler  ///////////////

    /// @notice Handles the receipt of a commodity by the wholesaler
    /// @dev Can only be executed by a wholesaler or a distributor
    /// @param _address The address of the commodity
    function wholesalerReceivedCommodity(address _address) external {
        require(
            userInfo[msg.sender].role == roles.wholesaler || userInfo[msg.sender].role == roles.distributor,
            "Only Wholesaler and Distributor can call this function"
        );

        commodityRecievedAtWholesaler(_address);
    }

    /// @notice Transfers a commodity from a wholesaler to a distributor
    /// @dev Can only be executed by a wholesaler or the current owner of the package
    /// @param _address The address of the commodity
    /// @param transporter The address of the transporter
    /// @param receiver The address of the receiver
    function transferCommodityW_D(address _address, address transporter, address receiver) external {
        require(
            userInfo[msg.sender].role == roles.wholesaler && msg.sender == Commodity(_address).getWDC()[0],
            "Only Wholesaler or current owner of package can call this function"
        );

        transferCommodityWtoD(_address, transporter, receiver);
    }

    /// @notice Returns the batch id by index for a wholesaler
    /// @dev Can only be executed by a wholesaler
    /// @param index The index of the batch
    /// @return packageID The id of the package
    function getBatchIdByIndexWD(uint256 index) external view returns (address packageID) {
        require(userInfo[msg.sender].role == roles.wholesaler, "Only Wholesaler Can call this function.");
        return CommodityWtoD[msg.sender][index];
    }

    /// @notice Returns the sub contract for a wholesaler
    /// @dev Can only be executed by a wholesaler
    /// @param _address The address of the wholesaler
    /// @return SubContractWD The address of the sub contract
    function getSubContractWD(address _address) external view returns (address SubContractWD) {
        return CommodityWtoDTxContract[_address];
    }

    ///////////////  Distributor Actions  ///////////////

    /// @notice This function is called when a distributor receives a commodity
    /// @dev Only a distributor or the current owner of the package can call this function
    /// @param _address The address of the distributor
    /// @param cid The commodity id
    function distributorReceivedCommodity(address _address, address cid) external {
        require(
            userInfo[msg.sender].role == roles.distributor && msg.sender == Commodity(_address).getWDC()[1],
            "Only Distributor or current owner of package can call this function"
        );

        commodityRecievedAtDistributor(_address, cid);
    }

    /// @notice This function transfers a commodity from a distributor to a final consumer
    /// @dev Only a distributor or the current owner of the package can call this function
    /// @param _address The address of the commodity
    /// @param transporter The address of the transporter
    /// @param receiver The address of the receiver
    function distributorTransferCommoditytoFinalConsumer(address _address, address transporter, address receiver)
        external
    {
        require(
            userInfo[msg.sender].role == roles.distributor && msg.sender == Commodity(_address).getWDC()[1],
            "Only Distributor or current owner of package can call this function"
        );
        transferCommodityDtoC(_address, transporter, receiver);
    }

    /// @notice This function returns the count of batches for a distributor
    /// @dev Only a distributor can call this function
    /// @return count The count of batches
    function getBatchesCountDC() external view returns (uint256 count) {
        require(userInfo[msg.sender].role == roles.distributor, "Only Distributor Can call this function.");
        return CommodityDtoC[msg.sender].length;
    }

    /// @notice This function returns the batch id by index for a distributor
    /// @dev Only a distributor can call this function
    /// @param index The index of the batch
    /// @return packageID The id of the package
    function getBatchIdByIndexDC(uint256 index) external view returns (address packageID) {
        require(userInfo[msg.sender].role == roles.distributor, "Only Distributor Can call this function.");
        return CommodityDtoC[msg.sender][index];
    }

    /// @notice This function returns the sub contract for a distributor
    /// @param _address The address of the distributor
    /// @return SubContractDP The address of the sub contract
    function getSubContractDC(address _address) external view returns (address SubContractDP) {
        return CommodityDtoCTxContract[_address];
    }

    ///////////////  End of Distributor Actions  ///////////////

    ///////////////  Consumer Actions  ///////////////

    /// @notice This function is called when a consumer receives a commodity
    /// @dev Only a consumer can call this function
    /// @param _address The address of the consumer
    /// @param cid The commodity id
    function consumerReceivedCommodity(address _address, address cid) external {
        require(userInfo[msg.sender].role == roles.consumer, "Only Consumer Can call this function.");
        commodityRecievedAtFinalConsumer(_address, cid);
    }

    /// @notice This function updates the status of a commodity
    /// @dev Only the consumer or the current owner of the package can call this function
    /// @param _address The address of the commodity
    /// @param Status The new status of the commodity
    function updateStatus(address _address, uint256 Status) external {
        require(
            userInfo[msg.sender].role == roles.consumer && msg.sender == Commodity(_address).getWDC()[2],
            "Only Consumer or current owner of package can call this function"
        );
        require(sale[_address] == salestatus(1), "Commodity Must be at Consumer");

        updateSaleStatus(_address, Status);
    }

    /// @notice This function returns the count of batches for a consumer
    /// @dev Only a wholesaler or the current owner of the package can call this function
    /// @return count The count of batches
    function getBatchesCountC() external view returns (uint256 count) {
        require(
            userInfo[msg.sender].role == roles.consumer,
            "Only Wholesaler or current owner of package can call this function"
        );
        return CommodityBatchAtFinalConsumer[msg.sender].length;
    }

    /// @notice This function returns the batch id by index for a consumer
    /// @dev Only a wholesaler or the current owner of the package can call this function
    /// @param index The index of the batch
    /// @return _address The address of the batch
    function getBatchIdByIndexC(uint256 index) external view returns (address _address) {
        require(
            userInfo[msg.sender].role == roles.consumer,
            "Only Wholesaler or current owner of package can call this function"
        );
        return CommodityBatchAtFinalConsumer[msg.sender][index];
    }
    ///////////////  End of Consumer Actions  ///////////////

    /// @notice This function verifies a signature
    /// @param p The address that is claimed to be the signer
    /// @param hash The hash of the signed message
    /// @param v The recovery id of the signature
    /// @param r The r value of the signature
    /// @param s The s value of the signature
    /// @return bool Whether the signature is valid or not
    function verify(address p, bytes32 hash, uint8 v, bytes32 r, bytes32 s) external pure returns (bool) {
        return ecrecover(hash, v, r, s) == p;
    }
}
