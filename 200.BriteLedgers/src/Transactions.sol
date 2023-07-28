// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

/**
 * @title Transactions contract
 * @author Tinotenda Joe
 * @dev A contract for creating and retrieving transaction entries.
 */
contract Transactions {
    /**
     * @dev Error message for transaction validation failure.
     */

    error TRANSACTION_ERROR_OCCURRED();

    uint256 public transactionCount;
    mapping(uint256 => transactions) public txns;

    /**
     * @dev Struct for storing transaction information.
     * @param transactionHash The hash of the transaction.
     * @param fromAddr The address of the sender.
     * @param toAddr The address of the receiver.
     * @param prevTransaction The hash of the previous transaction in the chain.
     * @param latitude The latitude of the transaction location.
     * @param longitude The longitude of the transaction location.
     * @param timestamp The timestamp of the transaction.
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
     * @dev Emitted when a new transaction entry is created.
     * @param _transactionHash The hash of the transaction.
     * @param _from The address of the sender.
     * @param _to The address of the receiver.
     * @param _prevTransaction The hash of the previous transaction in the chain.
     * @param _latitude The latitude of the transaction location.
     * @param _longitude The longitude of the transaction location.
     */

    event transactionCreated(
        bytes32 _transactionHash,
        address _from,
        address _to,
        bytes32 _prevTransaction,
        string _latitude,
        string _longitude
    );
    /**
     * @dev Creates a new transaction entry.
     * @notice  Throws if the previous transaction hash does not match with last transaction's hash
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
        if (transactionCount == 0) {
            // If this is the first transaction, add it to the mapping.
            txns[transactionCount] =
                transactions(_transactionHash, _from, _to, _prevTransaction, _latitude, _longitude, _timestamp);
        } else {
            // If this is not the first transaction, validate that the previous transaction matches.
            if (txns[transactionCount - 1].transactionHash != _prevTransaction) {
                revert TRANSACTION_ERROR_OCCURRED();
            }
            // Add the new transaction to the mapping.
            txns[transactionCount] =
                transactions(_transactionHash, _from, _to, _prevTransaction, _latitude, _longitude, _timestamp);
        }
        transactionCount += 1;
        emit transactionCreated(_transactionHash, _from, _to, _prevTransaction, _latitude, _longitude);
    }
    /**
     * @dev Retrieves all transaction entries.
     * @return An array of all transaction entries.
     */

    function getAllTransactions() public view returns (transactions[] memory) {
        transactions[] memory retainedTransactions = new transactions[](transactionCount);
        for (uint256 i; i < transactionCount; ++i) {
            retainedTransactions[i] = txns[i];
        }
        return retainedTransactions;
    }

    function getAllTransactionsCount() public view returns (uint256) {
        return transactionCount;
    }

    function getTransaction(uint256 id)
        public
        view
        returns (bytes32, address, address, bytes32, string memory, string memory, uint256)
    {
        transactions memory t = txns[id];
        return (t.transactionHash, t.fromAddr, t.toAddr, t.prevTransaction, t.latitude, t.longitude, t.timestamp);
    }
}
