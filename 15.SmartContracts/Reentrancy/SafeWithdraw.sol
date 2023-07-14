// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/// @title A contract for secure deposits and withdrawals
/// @author Joe Tinotenda
/// @notice This contract safely allows for deposits and withdrawals, following the Checks-Effects-Interactions pattern to prevent re-entrancy attacks.
/// @dev Update the contract to reflect latest Solidity version for production-level code.
contract SafeWithdrawContract {
	// User balances
	mapping(address => uint) public balance;

	/// @notice Deposit Ether into this contract
	/// @dev Payable function to accept Ether
	function deposit() public payable {
		balance[msg.sender] += msg.value;
	}

	/// @notice Withdraws Ether from the contract
	/// @dev Securely withdraws Ether following the Checks-Effects-Interactions pattern
	/// @param _amount The amount of Ether to withdraw
	function safeWithdraw(uint _amount) public {
		// Checks if the user has enough balance to withdraw
		require(
			balance[msg.sender] >= _amount,
			"Not enough balance to withdraw"
		);

		// Reduces the user balance
		balance[msg.sender] -= _amount;

		// Sends the Ether to the user
		payable(msg.sender).transfer(_amount);
	}
}
