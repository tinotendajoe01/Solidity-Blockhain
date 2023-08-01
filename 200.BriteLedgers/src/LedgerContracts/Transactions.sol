// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

/**
 * @title Transactions Ledger for Supply Chain Protocol
 * @author Tinotenda Joe
 * @notice This contract serves as a decentralized ledger for recording transactions within a supply chain protocol. It supports creating, retrieval, and count tracking of transaction entries.
 */
contract Transactions {
    error TRANSACTION_ERROR_OCCURRED(); // Tracks any transaction-related error

    address public Owner; // Address owner of the contract

    uint256 public transactionCount; // Tracks the total count of transactions

    // Mapping from transaction id to transactions
    mapping(uint256 => transactions) public txns;

    /**
     * @dev Represents a transaction in the ledger with respective details
     * @param transactionHash The unique identifier of the transaction
     * @param fromAddr The originator of the transaction
     * @param toAddr The destination of the transaction
     * @param prevTransaction Connects transactions in a chain format by tracking previous transaction hash
     * @param latitude Geographic coordinate specifying the North-South position of transaction
     * @param longitude Geographic coordinate specifying the East-West position of transaction
     * @param timestamp UNIX timestamp of when the transaction occurs
     */
    struct transactions {
        bytes32 transactionHash;
        address fromAddr;
        address toAddr;
        bytes32 prevTransaction;
        string latitude;
        string longitude;
        uint256 timestamp;
    }

    /**
     * @dev Event emitted once a transaction gets created successfully
     * @param _transactionHash Hash of the newly created transaction
     * @param _from Address initiating the transaction
     * @param _to Recipient address of the transaction
     * @param _prevTransaction Linked hash of the preceding transaction
     * @param _latitude Geographic coordinate - Latitude of the transaction
     * @param _longitude Geographic coordinate - Longitude of the transaction
     */
    event transactionCreated(
        bytes32 _transactionHash,
        address _from,
        address _to,
        bytes32 _prevTransaction,
        string _latitude,
        string _longitude
    );

    // Transaction contract constructor
    constructor(address _manufacturerAddr) {
        Owner = _manufacturerAddr;
    }

    /**
     * @dev Establishes a new transaction entry in the ledger
     * @param _transactionHash Id of the transaction
     * @param _from Source address of the transaction
     * @param _to Destination address for the transaction
     * @param _prevTransaction Hash of the previous transaction to maintain continuity
     * @param _latitude Latitude of the transaction
     * @param _longitude Longitude of the transaction
     * @notice Increases the total transaction count and emits an event at the end. Validates previous transaction for all transactions other than the first one.
     */
    function createTransactionEntry(
        bytes32 _transactionHash,
        address _from,
        address _to,
        bytes32 _prevTransaction,
        string memory _latitude,
        string memory _longitude
    ) public {
        uint256 _timestamp = block.timestamp;
        if (transactionCount == 0 || txns[transactionCount - 1].transactionHash == _prevTransaction) {
            txns[transactionCount] =
                transactions(_transactionHash, _from, _to, _prevTransaction, _latitude, _longitude, _timestamp);
            transactionCount++;
            emit transactionCreated(_transactionHash, _from, _to, _prevTransaction, _latitude, _longitude);
        } else {
            revert TRANSACTION_ERROR_OCCURRED();
        }
    }

    /**
     * @dev Fetch all the transaction entries recorded in the ledger
     * @return Array containing all the transactions in the ledger
     */
    function getAllTransactions() public view returns (transactions[] memory) {
        transactions[] memory retainedTransactions = new transactions[](transactionCount);
        for (uint256 i; i < transactionCount; ++i) {
            retainedTransactions[i] = txns[i];
        }
        return retainedTransactions;
    }

    /**
     * @dev Retrieves the total count of transactions in the ledger
     * @return Total count of transactions
     */
    function getAllTransactionsCount() public view returns (uint256) {
        return transactionCount;
    }

    /**
     * @dev Fetches the details of a specific transaction by its index
     * @param id Index of the transaction to fetch
     * @return Transaction details: hash, source address, destination address, previous transaction, latitude, longitude, timestamp
     */
    function getTransaction(uint256 id)
        public
        view
        returns (bytes32, address, address, bytes32, string memory, string memory, uint256)
    {
        transactions memory t = txns[id];
        return (t.transactionHash, t.fromAddr, t.toAddr, t.prevTransaction, t.latitude, t.longitude, t.timestamp);
    }
}
