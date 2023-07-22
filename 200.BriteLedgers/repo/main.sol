// SPDX-License-Identifier: SEE LICENSE IN LICENSE

/**
 * @title SupplyChainAccount
 * @dev This contract manages the supply chain account. It inherits from BaseAccount, TokenCallbackHandler, UUPSUpgradeable, Initializable.
 * @author Tinotenda Joe
 */

pragma solidity ^0.8.20;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {BaseAccount} from "@eth-inifitism/contracts/core";
import "./callback/TokenCallbackHandler.sol";

contract SupplyChainAccount is BaseAccount, TokenCallbackHandler, UUPSUpgradeable, Initializable {
    using ECDSA for bytes32;

    address public owner;

    IEntryPoint private immutable _entryPoint;

    event SimpleAccountInitialized(IEntryPoint indexed entryPoint, address indexed owner);

    /// @notice Restricts function's access to contract owner only
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    /// @inheritdoc BaseAccount
    function entryPoint() public view virtual override returns (IEntryPoint) {
        return _entryPoint;
    }

    /// @dev Function to receive Ether. Fallback function is triggered when the contract receives Ether
    receive() external payable {}

    /**
     * @notice Create a new SupplyChainAccount Contract
     * @dev Ensures the contract's entry points cannot be initialized more than once
     * @param anEntryPoint  EntryPoint for the SupplyChainAccount
     */
    constructor(IEntryPoint anEntryPoint) {
        _entryPoint = anEntryPoint;
        _disableInitializers();
    }

    /**
     * @notice validate the transaction is made by owner
     * @dev Ensures the transaction is made only by owner account
     */
    function _onlyOwner() internal view {
        require(msg.sender == owner || msg.sender == address(this), "only owner");
    }

    /**
     * @notice Execute a transaction called directly from owner, or by entryPoint
     * @dev Allows to execute a single transaction
     * @param dest Address where the transaction is directed
     * @param value Amount of wei to send with the transaction
     * @param func Encoded function call to execute
     */
    function execute(address dest, uint256 value, bytes calldata func) external {
        _requireFromEntryPointOrOwner();
        _call(dest, value, func);
    }

    /**
     * @notice Execute a sequence of transactions
     * @dev Allows to execute a batch of transactions
     * @param dest Array of addresses where the transactions are directed
     * @param func Array of encoded function calls to execute
     */
    function executeBatch(address[] calldata dest, bytes[] calldata func) external {
        _requireFromEntryPointOrOwner();
        require(dest.length == func.length, "wrong array lengths");
        for (uint256 i = 0; i < dest.length; i++) {
            _call(dest[i], 0, func[i]);
        }
    }

    /**
     * @notice Initializes the contract
     * @dev Sets the owner of the contract and emits an event
     * @param anOwner The address of the owner
     */
    function initialize(address anOwner) public virtual initializer {
        _initialize(anOwner);
    }

    /**
     * @notice Checks the current account deposit in the entryPoint
     * @dev Returns the balance of the contract in the entryPoint
     * @return The balance of the contract in the entryPoint
     */
    function getDeposit() public view returns (uint256) {
        return entryPoint().balanceOf(address(this));
    }

    /**
     * @notice Deposits more funds for this account in the entryPoint
     * @dev Sends ether to the entryPoint for this contract
     */
    function addDeposit() public payable {
        entryPoint().depositTo{value: msg.value}(address(this));
    }

    /**
     * @notice Withdraws value from the account's deposit
     * @dev Sends ether from the entryPoint to a specified address
     * @param withdrawAddress The address to send the ether to
     * @param amount The amount of ether to send
     */
    function withdrawDepositTo(address payable withdrawAddress, uint256 amount) public onlyOwner {
        entryPoint().withdrawTo(withdrawAddress, amount);
    }

    /**
     * @notice Authorizes an upgrade
     * @dev Checks if the caller is the owner of the contract
     * @param newImplementation The address of the new contract implementation
     */
    function _authorizeUpgrade(address newImplementation) internal view override {
        (newImplementation);
        _onlyOwner();
    }
}
