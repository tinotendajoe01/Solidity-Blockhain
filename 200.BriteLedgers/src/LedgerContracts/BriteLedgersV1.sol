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

//// Shared Ledger : supplier -> transporter -> manufacturer -> transporter -> whole-saler -> transporter -> distributor -> transporter -> Consumer
/**
 * @title BriteLedgersV1
 * @dev This contract models a supply chain process on the blockchain.
 * It includes multiple roles: supplier, transporter, manufacturer, wholesaler, distributor, and consumer.
 * Each role has its specific functions which can only be executed by an address assigned that role.
 * The contract uses a shared ledger to record every step of the process, making it transparent, secure, and efficient.
 * Unlike traditional supply chains, every stage of the process is recorded on the blockchain.
 * This contract is a part of the BriteLedgers protocol.
 * @dev This contract adopts the owner and authorized user design pattern, it uses cryptography for secure communication and ensures trustless interaction
 * in the supply chain.
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

    /**
     * @dev Creates a package of raw material.
     * Can only be executed by a supplier.
     * @param _description description of the raw material
     * @param _quantity quantity of the raw material
     * @param _transporterAddr address of the transporter
     * @param _manufacturerAddr address of the manufacturer
     */

    function supplierCreatesRawPackage(
        bytes32 _description,
        uint256 _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) external {
        require(userInfo[msg.sender].role == roles.supplier, "Role=>Supplier can use this function");

        createRawMaterialPackage(_description, _quantity, _transporterAddr, _manufacturerAddr);
    }

    function supplierGetPackageCount() external view returns (uint256) {
        require(userInfo[msg.sender].role == roles.supplier, "Role=>Supplier can use this function");

        return getNoOfPackagesOfSupplier();
    }

    function supplierGetRawMaterialAddresses() external view returns (address[] memory) {
        address[] memory ret = getAllPackages();
        return ret;
    }

    ///////////////  Transporter ///////////////

    function transporterHandlePackage(address _address, uint256 transporterType, address cid) external {
        require(userInfo[msg.sender].role == roles.transporter, "Only Transporter can call this function");
        require(transporterType > 0, "Transporter Type is incorrect");

        handlePackage(_address, transporterType, cid);
    }

    ///////////////  Manufacturer ///////////////

    function manufacturerReceivedRawMaterials(address _addr) external {
        require(userInfo[msg.sender].role == roles.manufacturer, "Only Manufacturer can access this function");
        manufacturerReceivedPackage(_addr, msg.sender);
    }

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

    function wholesalerReceivedCommodity(address _address) external {
        require(
            userInfo[msg.sender].role == roles.wholesaler || userInfo[msg.sender].role == roles.distributor,
            "Only Wholesaler and Distributor can call this function"
        );

        commodityRecievedAtWholesaler(_address);
    }

    function transferCommodityW_D(address _address, address transporter, address receiver) external {
        require(
            userInfo[msg.sender].role == roles.wholesaler && msg.sender == Commodity(_address).getWDC()[0],
            "Only Wholesaler or current owner of package can call this function"
        );

        transferCommodityWtoD(_address, transporter, receiver);
    }

    function getBatchIdByIndexWD(uint256 index) external view returns (address packageID) {
        require(userInfo[msg.sender].role == roles.wholesaler, "Only Wholesaler Can call this function.");
        return CommodityWtoD[msg.sender][index];
    }

    function getSubContractWD(address _address) external view returns (address SubContractWD) {
        return CommodityWtoDTxContract[_address];
    }

    ///////////////  Distributor  ///////////////

    function distributorReceivedCommodity(address _address, address cid) external {
        require(
            userInfo[msg.sender].role == roles.distributor && msg.sender == Commodity(_address).getWDC()[1],
            "Only Distributor or current owner of package can call this function"
        );

        commodityRecievedAtDistributor(_address, cid);
    }

    function distributorTransferCommoditytoFinalConsumer(address _address, address transporter, address receiver)
        external
    {
        require(
            userInfo[msg.sender].role == roles.distributor && msg.sender == Commodity(_address).getWDC()[1],
            "Only Distributor or current owner of package can call this function"
        );
        transferCommodityDtoC(_address, transporter, receiver);
    }

    function getBatchesCountDC() external view returns (uint256 count) {
        require(userInfo[msg.sender].role == roles.distributor, "Only Distributor Can call this function.");
        return CommodityDtoC[msg.sender].length;
    }

    function getBatchIdByIndexDC(uint256 index) external view returns (address packageID) {
        require(userInfo[msg.sender].role == roles.distributor, "Only Distributor Can call this function.");
        return CommodityDtoC[msg.sender][index];
    }

    function getSubContractDC(address _address) external view returns (address SubContractDP) {
        return CommodityDtoCTxContract[_address];
    }

    ///////////////  Consumer  ///////////////

    function consumerReceivedCommodity(address _address, address cid) external {
        require(userInfo[msg.sender].role == roles.consumer, "Only Consumer Can call this function.");
        commodityRecievedAtFinalConsumer(_address, cid);
    }

    function updateStatus(address _address, uint256 Status) external {
        require(
            userInfo[msg.sender].role == roles.consumer && msg.sender == Commodity(_address).getWDC()[2],
            "Only Consumer or current owner of package can call this function"
        );
        require(sale[_address] == salestatus(1), "Commodity Must be at Consumer");

        updateSaleStatus(_address, Status);
    }

    function getSalesInfo(address _address) external view returns (uint256 Status) {
        return salesInfo(_address);
    }

    function getBatchesCountC() external view returns (uint256 count) {
        require(
            userInfo[msg.sender].role == roles.consumer,
            "Only Wholesaler or current owner of package can call this function"
        );
        return CommodityBatchAtFinalConsumer[msg.sender].length;
    }

    function getBatchIdByIndexC(uint256 index) external view returns (address _address) {
        require(
            userInfo[msg.sender].role == roles.consumer,
            "Only Wholesaler or current owner of package can call this function"
        );
        return CommodityBatchAtFinalConsumer[msg.sender][index];
    }

    // function verify(address p, bytes32 hash, uint8 v, bytes32 r, bytes32 s) external view returns(bool) {
    //     return ecrecover(hash, v, r, s) == p;
    // }
}
