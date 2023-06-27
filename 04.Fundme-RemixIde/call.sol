// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract SendEther {
	// Declare a boolean variable 'locked' to act as a mutex
	bool private locked;

	// Define a modifier 'noReentrancy' to prevent reentrant calls
	modifier noReentrancy() {
		// Check if 'locked' is false, otherwise throw an error
		require(!locked, "Reentrant call");

		// Set 'locked' to true before executing the function
		locked = true;


		// Execute the function
		_;

		// Set 'locked' back to false after executing the function
		locked = false;
	}

	// Define a function 'sendViaCall' that accepts an address and an amount of Ether
	function sendViaCall(address payable _to) public payable noReentrancy {
		// Call the recipient address with the specified amount of Ether
		// Store the success status and returned data in variables 'sent' and 'data'
		(bool sent, bytes memory data) = _to.call{ value: msg.value }("");

		// Check if the call was successful, otherwise throw an error
		require(sent, "Failed to send Ether");
	}
}
