//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19; //stating our version

contract SimpleStorage {
	uint256 myFavoriteNumber; //defaulted to 0 i.e uint256 favoriteNumber =0
	//uint256[] listofFavoriteNumbers;//[8,6,4,3]
	struct Person {
		uint256 favoriteNumber;
		string name;
	}
	// Person public myFriend = Person(7, 'James');
	Person[] public listofPeople; //dynamic array
	mapping(string => uint256) public nameToFavoriteNumber;

	function store(uint256 _favoriteNumber) public virtual {
		myFavoriteNumber = _favoriteNumber;
	}

	//view ,pure
	function retrieve() public view returns (uint256) {
		return myFavoriteNumber;
	}

	//calldata, memory, storage
	function addPerson(string memory _name, uint256 _favoriteNumber) public {
		listofPeople.push(Person(_favoriteNumber, _name));
		nameToFavoriteNumber[_name] = _favoriteNumber;
	}

	function getPersonFavoriteNumber(
		string calldata _name
	) public view returns (uint256) {
		return nameToFavoriteNumber[_name];
	}

	function getTotalPeople() public view returns (uint256) {
		return listofPeople.length;
	}

	function getPersonAtIndex(
		uint256 i
	) public view returns (string memory, uint256) {
		require(i < listofPeople.length, "indext out of bounds");
		Person memory p = listofPeople[i];

		return (p.name, p.favoriteNumber);
	}

	function deletePerson(string memory _name) public {
		require(listofPeople.length > 0, "No people in the list");

		uint256 indexToDelete = 0;
		bool found = false;

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

		for (uint256 i = indexToDelete; i < listofPeople.length - 1; i++) {
			listofPeople[i] = listofPeople[i + 1];
		}

		listofPeople.pop();
		delete nameToFavoriteNumber[_name];
	}
}
