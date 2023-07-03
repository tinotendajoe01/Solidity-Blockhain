// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
error Project_Does_Not_Exist();

contract FundProject is ProjectsStorage {
	constructor() {}

	function fund(string memory _name) public payable {
		uint256 projectId = projectNameToId[_name];

		if (projectId == 0) revert Project_Does_Not_Exist();
		Project storage project = listofProjects[projectId - 1];
		project.totalFundsRaised += msg.value;
		project.funders.push(msg.sender);
	}

	function projectBalance(string memory _name) public view returns (uint256) {
		uint256 projectId = projectNameToId[_name];

		if (projectId == 0) revert Project_Does_Not_Exist();
		Project storage project = listofProjects[projectId - 1];
		return project.totalFundsRaised;
	}
}
