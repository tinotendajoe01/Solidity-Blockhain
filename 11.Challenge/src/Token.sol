// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FundingToken is ERC20 {
	constructor(uint256 initialSupply) ERC20("FundingToken", "FT") {
		_mint(msg.sender, initialSupply);
	}

	function fundProject(address project, uint256 amount) public {
		require(
			transferFrom(msg.sender, projectAdress, amount),
			"Transfer failed"
		);
	}
}
