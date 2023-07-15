// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectsStorage {
	mapping(address => uint256) private _funds;

	function deposit(address project, uint256 amount) public {
		_funds[project] += amount;
	}

	function getFunds(address project) public view returns (uint256) {
		return _funds[project];
	}
}
