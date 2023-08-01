// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployTransactions} from "../../script/DeployTransactions.s.sol";
import {Transactions} from "../../src//LedgerContracts/Transactions.sol";

contract TestTransactions is Test {
    //test type variables

    address public receiver = makeAddr("receiver");

    string public latitude = "37.7749 N";
    string public longitude = "122.4194 W";
    bytes32 public previousTransaction = keccak256(abi.encode(block.timestamp - 1));
    bytes32 public transactionHash = keccak256(abi.encode(block.timestamp));

    Transactions public transactions;

    function setUp() external {
        DeployTransactions deployer = new DeployTransactions();
        transactions = deployer.run();
    }

    function testCreateTransactionEntryWhenCountisZero() public {
        // Initialize the variables ...
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );

        uint256 expectedTransactionsCount = 1;
        uint256 actualTransactionsCount = transactions.transactionCount();

        // Retrieve each property of the transaction
        (
            bytes32 actualTransactionHash,
            address actualFromAddr,
            address actualToAddr,
            bytes32 actualPrevTransaction,
            string memory actualLatitude,
            string memory actualLongitude,
            uint256 actualTimestamp
        ) = transactions.getTransaction(actualTransactionsCount - 1);

        // Check if each property of the transaction new matches the expected transaction
        assertEq(actualTransactionHash, transactionHash);
        assertEq(actualFromAddr, msg.sender);
        assertEq(actualToAddr, receiver);
        assertEq(actualPrevTransaction, previousTransaction);
        assertEq(actualLatitude, latitude);
        assertEq(actualLongitude, longitude);
        assertEq(actualTimestamp, block.timestamp);
        assertEq(expectedTransactionsCount, actualTransactionsCount);
    }

    function testCreateTransactionEntryWhenCountisNotZero() public {
        // Initialize the variables for the first transaction
        bytes32 firstTransactionHash = keccak256(abi.encode(block.timestamp));
        transactions.createTransactionEntry(
            firstTransactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );

        // Initialize the variables for the second transaction
        bytes32 secondTransactionHash = keccak256(abi.encode(block.timestamp + 1));
        transactions.createTransactionEntry(
            secondTransactionHash, msg.sender, receiver, firstTransactionHash, latitude, longitude
        );

        uint256 expectedTransactionsCount = 2;
        uint256 actualTransactionsCount = transactions.transactionCount();

        // Retrieve each property of the second transaction
        (
            bytes32 actualTransactionHash,
            address actualFromAddr,
            address actualToAddr,
            bytes32 actualPrevTransaction,
            string memory actualLatitude,
            string memory actualLongitude,
            uint256 actualTimestamp
        ) = transactions.getTransaction(actualTransactionsCount - 1);

        // Check if each property of the second transaction matches the expected values
        assertEq(actualTransactionHash, secondTransactionHash);
        assertEq(actualFromAddr, msg.sender);
        assertEq(actualToAddr, receiver);
        assertEq(actualPrevTransaction, firstTransactionHash);
        assertEq(actualLatitude, latitude);
        assertEq(actualLongitude, longitude);
        assertEq(actualTimestamp, block.timestamp);
        assertEq(expectedTransactionsCount, actualTransactionsCount);
    }

    function testCreateTransactionEntryRevertsWhenBlockHashesDonNotMatch() public {
        // Initialize the variables ...
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );
        vm.expectRevert(Transactions.TRANSACTION_ERROR_OCCURRED.selector);
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );
    }

    function testGetAllTransactionsWhenNoTransactions() public {
        Transactions.transactions[] memory allTransactions = transactions.getAllTransactions();
        assertEq(allTransactions.length, 0, "No transactions should be returned when there are none");
    }

    function testGetAllTransactionsWhenOneTransaction() public {
        // Create a transaction
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );

        Transactions.transactions[] memory allTransactions = transactions.getAllTransactions();
        assertEq(allTransactions.length, 1, "One transaction should be returned when there is one");

        // Check if the properties of the returned transaction match the expected values
        assertEq(allTransactions[0].transactionHash, transactionHash);
        assertEq(allTransactions[0].fromAddr, msg.sender);
        assertEq(allTransactions[0].toAddr, receiver);
        assertEq(allTransactions[0].prevTransaction, previousTransaction);
        assertEq(allTransactions[0].latitude, latitude);
        assertEq(allTransactions[0].longitude, longitude);
    }

    function testGetAllTransactionsWhenMultipleTransactions() public {
        // Create the first transaction
        bytes32 firstTransactionHash = keccak256(abi.encode(block.timestamp));
        transactions.createTransactionEntry(
            firstTransactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );

        // Create the second transaction
        bytes32 secondTransactionHash = keccak256(abi.encode(block.timestamp + 1));
        transactions.createTransactionEntry(
            secondTransactionHash, msg.sender, receiver, firstTransactionHash, latitude, longitude
        );

        Transactions.transactions[] memory allTransactions = transactions.getAllTransactions();
        assertEq(allTransactions.length, 2, "Two transactions should be returned when there are two");

        // Check if the properties of the returned transactions match the expected values
        assertEq(allTransactions[0].transactionHash, firstTransactionHash);
        assertEq(allTransactions[0].fromAddr, msg.sender);
        assertEq(allTransactions[0].toAddr, receiver);
        assertEq(allTransactions[0].prevTransaction, previousTransaction);
        assertEq(allTransactions[0].latitude, latitude);
        assertEq(allTransactions[0].longitude, longitude);

        assertEq(allTransactions[1].transactionHash, secondTransactionHash);
        assertEq(allTransactions[1].fromAddr, msg.sender);
        assertEq(allTransactions[1].toAddr, receiver);
        assertEq(allTransactions[1].prevTransaction, firstTransactionHash);
        assertEq(allTransactions[1].latitude, latitude);
        assertEq(allTransactions[1].longitude, longitude);
    }

    // Test for getAllTransactionsCount function
    function testGetAllTransactionsCount() public {
        uint256 txCount = transactions.getAllTransactionsCount();
        uint256 expectedTxCount = 0; // Assuming no transactions initially

        assertEq(txCount, expectedTxCount, "getAllTransactionsCount should return no transaction initially");

        // Create a transaction
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );
        txCount = transactions.getAllTransactionsCount();
        expectedTxCount = 1; // Now there should be one transaction

        assertEq(txCount, expectedTxCount, "getAllTransactionsCount should return one after a transaction is added");
    }

    // Test for getTransaction function
    function testGetTransaction() public {
        // Create a transaction
        transactions.createTransactionEntry(
            transactionHash, msg.sender, receiver, previousTransaction, latitude, longitude
        );

        (
            bytes32 returnedTransactionHash,
            address returnedFrom,
            address returnedTo,
            bytes32 returnedPrevTransaction,
            string memory returnedLatitude,
            string memory returnedLongitude,
            uint256 returnedTimestamp
        ) = transactions.getTransaction(0); // Getting the first transaction

        // Compare returned values with expected values
        assertEq(returnedTransactionHash, transactionHash);
        assertEq(returnedFrom, msg.sender);
        assertEq(returnedTo, receiver);
        assertEq(returnedPrevTransaction, previousTransaction);
        assertEq(returnedLatitude, latitude);
        assertEq(returnedLongitude, longitude);
        assertEq(returnedTimestamp, block.timestamp);
    }
}
