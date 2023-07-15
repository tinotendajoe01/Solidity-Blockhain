// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FundingToken.sol";
import "./ProjectsStorage.sol";

contract FundProject {
	FundingToken private _token;
	ProjectsStorage private _storage;

	constructor(address token, address storageAddress) {
		_token = FundingToken(token);
		_storage = ProjectsStorage(storageAddress);
	}

	function fund(address project, uint256 amount) public {
		_token.transferFrom(msg.sender, address(this), amount);
		_storage.deposit(project, amount);
	}
}
