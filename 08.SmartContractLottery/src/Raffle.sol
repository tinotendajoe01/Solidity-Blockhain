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
	uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
	address payable[] private s_players;
     uint256 private  s_lastTimeStamp;

event  EnteredRaffle(address indexed player)
	constructor(uint256 entranceFee, uint256 interval) {
		i_entranceFee = entranceFee;
        i_interval = interval;
         s_lastTimeStamp= block.timestamp;
	}

	function enterRaffle() external payable {
		// require(msg.value >= i_entranceFee, "Not enough ETH sent");
		if (msg.value >= i_entranceFee) revert Raffle__NotEnoughEthSent();
		s_players.push(payable(msg.sender)); 
        emit EnteredRaffle(msg.sender);
	}

	function pickWinner() external {
        if(block.timestamp - s_lastTimeStamp< i_interval){
            revert();
        };

    }

	/**  Getter fxs */
	function getEntranceFee() external view returns (uint256) {
		return i_entranceFee;
	}
}
