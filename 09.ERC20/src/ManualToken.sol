// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract ManualToken {
	constructor() {}

	mapping(address => uint256) private s_balances;

	function Name() public pure returns (string memory) {
		return "Manual Token";
	}

	function totalSupply() public pure returns (uint256) {
		return 100 ether;
	}

	function decimals() public pure returns (uint8) {
		return 18;
	}

	function balanceOf(address _owner) public view returns (uint256) {
		return s_balances[_owner];
	}

	function transfer(
		address _to,
		uint256 _amount
	) public returns (bool success) {
		uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
		s_balances[msg.sender] -= _amount;
		s_balances[_to] += _amount;
		require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
	}
}
