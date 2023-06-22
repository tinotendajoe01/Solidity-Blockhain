// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20; // Stating the Solidity version [bitdegree.org](https://www.bitdegree.org/learn/solidity-syntax)

// Defining a contract named SimpleStorage
contract SimpleStorage {
	// Declaring a state variable to store a favorite number
	uint256 myFavoriteNumber;

	// Defining a struct to represent a Person with a name and a favorite number
	struct Person {
		uint256 favoriteNumber;
		string name;
	}

	// Declaring a dynamic array to store a list of people
	Person[] public listofPeople;

	// Declaring a mapping to associate a name with a favorite number
	mapping(string => uint256) public nameToFavoriteNumber;

	// Function to store a favorite number
	function store(uint256 _favoriteNumber) public virtual {
		myFavoriteNumber = _favoriteNumber;
	}

	// Function to retrieve the stored favorite number
	function retrieve() public view returns (uint256) {
		return myFavoriteNumber;
	}

	// Function to add a person with their name and favorite number
	function addPerson(string memory _name, uint256 _favoriteNumber) public {
		listofPeople.push(Person(_favoriteNumber, _name));
		nameToFavoriteNumber[_name] = _favoriteNumber;
	}

	// Function to get a person's favorite number by their name
	function getPersonFavoriteNumber(
		string calldata _name
	) public view returns (uint256) {
		return nameToFavoriteNumber[_name];
	}

	// Function to get the total number of people in the list
	function getTotalPeople() public view returns (uint256) {
		return listofPeople.length;
	}

	// Function to get a person at a specific index in the list
	function getPersonAtIndex(
		uint256 i
	) public view returns (string memory, uint256) {
		require(i < listofPeople.length, "index out of bounds");
		Person memory p = listofPeople[i];
		return (p.name, p.favoriteNumber);
	}

	// Function to delete a person by their name from the list
	function deletePerson(string memory _name) public {
		require(listofPeople.length > 0, "No people in the list");

		uint256 indexToDelete = 0;
		bool found = false;

		// Find the person's index in the list
		for (uint256 i = 0; i < listofPeople.length; i++) {
			if (
				keccak256(bytes(listofPeople[i].name)) ==
				keccak256(bytes(_name))
			) {
				indexToDelete = i;
				found = true;
				break;
			}
		}

		require(found, "Person not found");

		// Shift the elements in the list to remove the person
		for (uint256 i = indexToDelete; i < listofPeople.length - 1; i++) {
			listofPeople[i] = listofPeople[i + 1];
		}

		// Remove the last element from the list
		listofPeople.pop();

		// Delete the person's entry in the mapping
		delete nameToFavoriteNumber[_name];
	}
}
