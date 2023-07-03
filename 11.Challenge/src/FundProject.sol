// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";

contract FundProject is ProjectsStorage {
	constructor() {}

	function fundProject(string memory _name) public payable {
		uint256 projectId = projectNameToId[_name];
		require(projectId != 0, "Project does not exist");
		Project storage project = listofProjects[projectId - 1];
		project.totalFundsRaised += msg.value;
		project.funders.push(msg.sender);
	}

	function projectBalance(string memory _name) public view returns (uint256) {
		uint256 projectId = projectNameToId[_name];
		require(projectId != 0, "Project does not exist");
		Project storage project = listofProjects[projectId - 1];
		return project.totalFundsRaised;
	}
}
