// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { DeploySimpleStorage } from "../script/DeploySimpleStorage.s.sol";
import { SimpleStorage } from "../src/SimpleStorage.sol";

// Define a new contract called SimpleStorageTest that inherits from the Test contract
contract SimpleStorageTest is Test {
	SimpleStorage public simpleStorage; // Contract variable instance of type SimpleStorage contract

	// Set up function to initialize the SimpleStorage contract for testing
	function setUp() external {
		DeploySimpleStorage deployer = new DeploySimpleStorage();
		simpleStorage = deployer.run();
	}

	// Test that the store function correctly stores a favorite number
	function testStoreIsStoringFavoriteNumber() public {
		// Arrange: Set a favorite number to store
		uint256 favoriteNumber = 9;
		// Act: Call the store function to store the favorite number
		simpleStorage.store(favoriteNumber);
	}

	// Test that the retrieve function correctly retrieves a stored favorite number
	function testRetrieveFavoriteNumber() public {
		// Arrange: Set a favorite number to store
		uint256 favoriteNumber = 9;
		// Act: Call the store function to store the favorite number
		simpleStorage.store(favoriteNumber);
		// Retrieve the stored favorite number
		uint256 favoriteNumberRetrieved = simpleStorage.retrieve();
		// Assert: Check that the retrieved favorite number is equal to the expected value
		assertEq(favoriteNumberRetrieved, 9);
	}

	// Test that the addPerson function correctly adds a person and getPersonAtIndex returns correct person details
	function testAddPersonAndGetDetails() public {
		// Act: Call the addPerson function to add a new person with name "John" and favorite number 8
		simpleStorage.addPerson("John", 8);

		// Retrieve the person details at index 0
		(string memory name, uint256 favoriteNumber) = simpleStorage
			.getPersonAtIndex(0);
		// Assert: Check that the retrieved person details are correct
		assertEq(name, "John");
		assertEq(favoriteNumber, 8, "Favorite number should be 8");
	}

	// Test that the getPersonFavoriteNumber function returns the correct favorite number for a person
	function testGetFavoriteNumber() public {
		// Add a person with name "John" and favorite number 8
		simpleStorage.addPerson("John", 8);
		// Retrieve the favorite number for the person named "John"
		uint256 favoriteNumber = simpleStorage.getPersonFavoriteNumber("John");
		// Assert: Check that the retrieved favorite number is correct
		assertEq(favoriteNumber, 8);
	}

	// Test that the getTotalPeople function returns the correct number of total people
	function testGetTotalPipo() public {
		// Add a person with name "John" and favorite number 8
		simpleStorage.addPerson("John", 8);
		// Retrieve the total number of people
		uint256 total = simpleStorage.getTotalPeople();
		// Assert: Check that the total number of people is correct
		assertEq(total, 1);
	}

	// Test that the deletePerson function correctly deletes a person with a valid name
	function testDeletePerson_ValidName() public {
		// Add two people with names "John" and "Alice" and their respective favorite numbers
		simpleStorage.addPerson("John", 8);
		simpleStorage.addPerson("Alice", 5);

		// Call the deletePerson function to delete the person named "John"
		simpleStorage.deletePerson("John");

		// Retrieve the total number of people after deletion
		uint256 totalPeople = simpleStorage.getTotalPeople();
		// Assert: Check that the total number of people is correct after deletion
		assertEq(
			totalPeople,
			1,
			"Total people should be 1 after deleting John"
		);

		// Retrieve the remaining person details
		(
			string memory remainingPersonName,
			uint256 remainingPersonFavoriteNumber
		) = simpleStorage.getPersonAtIndex(0);
		// Assert: Check that the remaining person details are correct
		assertEq(
			remainingPersonName,
			"Alice",
			"The remaining person should be Alice"
		);
	}

	// Test that the deletePerson function reverts when called with an invalid name
	function testDeletePerson_InvalidName() public {
		// Add two people with names "John" and "Alice" and their respective favorite numbers
		simpleStorage.addPerson("John", 8);
		simpleStorage.addPerson("Alice", 5);
		// Expect the deletePerson function to revert when called with an invalid name
		vm.expectRevert();
		simpleStorage.deletePerson("Tatenda");
	}

	function testDeletePerson_EmptyList() public {
		vm.expectRevert();
		simpleStorage.deletePerson("Tatenda");
	}
}
