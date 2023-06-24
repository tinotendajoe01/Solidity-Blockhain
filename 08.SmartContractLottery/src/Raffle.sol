// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

/**
 * @title A  Raffle contract
 * @author Tinotenda Joe
 * @notice This is a contract for creating a raffle
 * @dev Implements Ckainlink VRFv2
 */

contract Raffle {
	error Raffle__NotEnoughEthSent();
	uint256 private i_entranceFee;

	constructor(uint256 entranceFee) {
		i_entranceFee = entranceFee;
	}

	function enterRaffle() external payable {
		// require(msg.value >= i_entranceFee, "Not enough ETH sent");
		if (msg.value >= i_entranceFee) revert Raffle__NotEnoughEthSent();
	}

	function pickWinner() public {}

	/**  Getter fxs */
	function getEntranceFee() external view returns (uint256) {
		return i_entranceFee;
	}
}
