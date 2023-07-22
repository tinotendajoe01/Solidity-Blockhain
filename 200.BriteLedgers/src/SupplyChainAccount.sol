// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.20;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {BaseAccount} from "@eth-infinitism/contracts/core/BaseAccount.sol";
import "./callback/TokenCallbackHandler.sol";
import {IEntryPoint} from "@eth-infinitism/contracts/interfaces/IEntryPoint.sol";
import {UserOperation} from "@eth-infinitism/contracts/interfaces/UserOperation.sol";
import {IPharmaceutics} from "./interfaces/IPharmaceutics.sol";

/**
 * @title SupplyChainAccount Contract
 * @notice This contract is used for ...
 * @dev Implementation of the SupplyChainAccount.
 */
contract SupplyChainAccount is BaseAccount, TokenCallbackHandler, UUPSUpgradeable, Initializable {
    using ECDSA for bytes32;

    /**
     * @dev Record the owner of the contract
     */
    address public owner;

    IEntryPoint private immutable _entryPoint;
    IPharmaceutics private pharmaceuticsContract;

    struct User {
        address accountAddress;
        uint8 role; // 1: supplier, 2: consumer
        bool verified;
    }

    mapping(address => User) private users;
    /**
     * @notice Emitted when the supply chain account is initialized
     * @param entryPoint The entry point of the supply chain account
     * @param owner The owner of the supply chain account
     */

    event SupplyChainAccountInitialized(IEntryPoint indexed entryPoint, address indexed owner);

    /**
     * @notice Ensure the caller is the owner
     * @dev Restricts function usage to only the contract owner
     */
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    modifier onlySupplier() {
        require(users[msg.sender].role == 1, "Only suppliers can access this function");
        _;
    }

    modifier onlyConsumer() {
        require(users[msg.sender].role == 2, "Only consumers can access this function");
        _;
    }
    /// @inheritdoc BaseAccount

    function entryPoint() public view virtual override returns (IEntryPoint) {
        return _entryPoint;
    }

    receive() external payable {}

    constructor(IEntryPoint anEntryPoint, address pharmaceuticsContractAddress) {
        _entryPoint = anEntryPoint;
        pharmaceuticsContract = IPharmaceutics(pharmaceuticsContractAddress);
        _disableInitializers();
    }

    function _onlyOwner() internal view {
        //directly from EOA owner, or through the account itself (which gets redirected through execute())
        require(msg.sender == owner || msg.sender == address(this), "only owner");
    }

    /**
     * @notice Transfer `value` amount of Ether to the `dest` address.
     * @dev Called directly from owner, or by entryPoint
     * @param dest The address of the recipient
     * @param value The amount to send
     * @param func Bytes data representing the function call
     */
    function execute(address dest, uint256 value, bytes calldata func) external {
        _requireFromEntryPointOrOwner();
        require(users[msg.sender].verified, "User is not verified");

        _call(dest, value, func);
    }

    /**
     * @notice Execute a sequence of transactions
     * @dev Called directly from owner, or by entryPoint
     * @param dest The array of addresses of the recipients
     * @param func The array of bytes data representing the function calls
     */
    function executeBatch(address[] calldata dest, bytes[] calldata func) external onlySupplier {
        _requireFromEntryPointOrOwner();
        require(dest.length == func.length, "wrong array lengths");
        for (uint256 i = 0; i < dest.length; i++) {
            if (
                func[i].length >= 4 && func[i][0] == bytes1(0x22) && func[i][1] == bytes1(0xea)
                    && func[i][2] == bytes1(0x3d) && func[i][3] == bytes1(0x46)
            ) {
                require(users[msg.sender].verified, "User is not verified");
            }
            _call(dest[i], 0, func[i]);
        }
    }
    /**
     * @dev The _entryPoint member is immutable, to reduce gas consumption.  To upgrade EntryPoint,
     * a new implementation of SimpleAccount must be deployed with the new EntryPoint address, then upgrading
     * the implementation by calling `upgradeTo()`
     */

    function initialize(address anOwner) public virtual initializer {
        _initialize(anOwner);
    }

    function _initialize(address anOwner) internal virtual {
        owner = anOwner;
        emit SupplyChainAccountInitialized(_entryPoint, owner);
    }
    // Require the function call went through EntryPoint or owner

    function _requireFromEntryPointOrOwner() internal view {
        require(msg.sender == address(entryPoint()) || msg.sender == owner, "account: not Owner or EntryPoint");
    }

    /// implement template method of BaseAccount
    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
        internal
        virtual
        override
        returns (uint256 validationData)
    {
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        address recoveredAddress = hash.recover(userOp.signature);

        if (users[msg.sender].verified) {
            if (users[msg.sender].role == 1) {
                require(recoveredAddress == owner, "Invalid signature");
            } else {
                require(recoveredAddress == msg.sender, "Invalid signature");
            }
            return 0;
        } else {
            if (recoveredAddress != owner) {
                return SIG_VALIDATION_FAILED;
            }
            return 0;
        }
    }

    function _call(address target, uint256 value, bytes memory data) internal {
        (bool success, bytes memory result) = target.call{value: value}(data);
        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    /**
     * @notice Check current account deposit in the entryPoint
     * @dev Called directly from owner, or by entryPoint
     * @return The current deposit of the account in the entryPoint
     */
    function getDeposit() public view returns (uint256) {
        return entryPoint().balanceOf(address(this));
    }

    /**
     * @notice Deposit more funds for this account in the entryPoint
     * @dev Called directly from owner, or by entryPoint
     */
    function addDeposit() public payable {
        entryPoint().depositTo{value: msg.value}(address(this));
    }

    function createAccount(uint8 role) public {
        require(users[msg.sender].accountAddress == address(0), "Account already exists");
        require(role == 1 || role == 2, "Invalid role");
        users[msg.sender] = User(msg.sender, role, false);
    }

    function verifyUser(address userAddress) public onlyOwner {
        users[userAddress].verified = true;
    }

    function verifyDrugAuthenticity(bytes32 hash, bytes memory signature) public view returns (bool) {
        return ECDSA.recover(hash, signature) == address(this);
    }

    function addDrug(string memory name, string memory description) external {
        pharmaceuticsContract.addDrug(name, description);
    }

    function transferDrugOwnership(uint256 drugId, address recipient) external {
        pharmaceuticsContract.transferDrugOwnership(drugId, recipient);
    }

    function placeOrder(uint256 drugId, address seller) external {
        pharmaceuticsContract.placeOrder(drugId, seller);
    }

    function fulfillOrder(uint256 orderId) external {
        pharmaceuticsContract.fulfillOrder(orderId);
    }

    function getDrug(uint256 drugId)
        external
        view
        returns (
            string memory name,
            string memory description,
            address manufacturer,
            address currentOwner,
            address[] memory ownershipChain,
            bool authenticityStatus
        )
    {
        IPharmaceutics.Drug memory drug = pharmaceuticsContract.drugs(drugId);
        return (
            drug.name,
            drug.description,
            drug.manufacturer,
            drug.currentOwner,
            drug.ownershipChain,
            drug.authenticityStatus
        );
    }

    function getOrder(uint256 orderId)
        external
        view
        returns (uint256 drugId, address buyer, address seller, bool fulfillmentStatus)
    {
        IPharmaceutics.Order memory order = pharmaceuticsContract.orders(orderId);
        return (order.drugId, order.buyer, order.seller, order.fulfillmentStatus);
    }

    function getDrugCounter() external view returns (uint256) {
        return pharmaceuticsContract.drugCounter();
    }

    function getOrderCounter() external view returns (uint256) {
        return pharmaceuticsContract.orderCounter();
    }

    /**
     * @notice Withdraw value from the account's deposit
     * @dev Called directly from owner, or by entryPoint
     * @param withdrawAddress target to send to
     * @param amount to withdraw
     */

    function withdrawDepositTo(address payable withdrawAddress, uint256 amount) public onlyOwner {
        entryPoint().withdrawTo(withdrawAddress, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal view override {
        (newImplementation);
        _onlyOwner();
    }
}
