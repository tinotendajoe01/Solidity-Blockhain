// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title A contract for demonstrate payable functions and addresses
/// @author Joe Tinotenda
/// @notice For now, this contract just show how payable functions and addresses can receive ether into the contract
contract Vulnerable {
	mapping(address => uint) public balance;

	function deposit() public payable {
		balance[msg.sender] += msg.value;
	}

	function withdraw() public payable {
		require(balance[msg.sender] >= msg.value);
		payable(msg.sender).transfer(msg.value);
		balance[msg.sender] -= msg.value;
	}

	// To fix this, you should follow the Checks-Effects-Interactions pattern
	//  while writing your contract functions.
	//  In your withdraw function, you should first deduct the amount from the user's
	//   balance and then transfer the ether:
	///@notice see full contract SafeWithdraw.sol
}
