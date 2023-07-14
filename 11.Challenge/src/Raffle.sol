// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { FundRaffleMoodNft } from "./FundRaffleNft.sol";
error Project_Does_Not_Exist();
error RAFFLE_CANNOT_BE_ENTERED_UNTIL_FUNDING_GOAL_IS_REACHED();

contract Raffle {
	ProjectsStorage private projectsStorage;
	FundRaffleMoodNft private fundRaffleMoodNft;

	constructor(
		address projectsStorageAddress,
		address fundRaffleMoodNftAddress
	) {
		projectsStorage = ProjectsStorage(projectsStorageAddress);
		fundRaffleMoodNft = FundRaffleMoodNft(fundRaffleMoodNftAddress);
	}

	function raffle(string memory _name) public {
		if (!projectsStorage.checkGoalReached(_name)) {
			revert RAFFLE_CANNOT_BE_ENTERED_UNTIL_FUNDING_GOAL_IS_REACHED();
		}
		uint256 projectId = projectsStorage.getProjectId(_name);
		if (projectId == 0) {
			revert Project_Does_Not_Exist();
		}
		ProjectsStorage.Project memory project = getProjectDetails(projectId);

		// The random index of the selected funder
		uint256 winnerIndex = uint256(
			keccak256(abi.encodePacked(block.timestamp, block.prevrandao))
		) % project.funders.length;

		// The address of the selected funder
		address winner = project.funders[winnerIndex];

		// Transfer all NFTs of the project to the winner
		transferAllNfts(project.projectAddress, winner);

		// Remove all funders after the raffle (if you want to do the raffle only once)
		delete project.funders;
	}

	function transferAllNfts(address from, address to) public {
		// Get the token balance of the 'from' address
		uint256 balance = fundRaffleMoodNft.balanceOf(from);

		// Transfer each token to the 'to' address
		for (uint256 i = 0; i < balance; i++) {
			// The token ID to be transfered
			uint256 tokenId = fundRaffleMoodNft.tokenOfOwnerByIndex(from, i);

			// Transfer the token
			fundRaffleMoodNft.transferFrom(from, to, tokenId);
		}
	}

	// function getProjectDetails(
	// 	uint256 projectId
	// ) public view returns (ProjectsStorage.Project memory) {
	// 	return projectsStorage.getProject(projectId);
	// }
	function getProjectDetails(
		uint256 projectId
	) public view returns (ProjectsStorage.Project memory) {
		ProjectsStorage.Project memory project = projectsStorage.getProject(
			projectId
		);
		return project;
	}
}
