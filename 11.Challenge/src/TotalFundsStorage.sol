// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract TotalFundsStorage {
	struct Project {
		string name;
		uint256 totalFundsInProject;
	}
	Project[] public listofProjects;
	mapping(string => uint256) public projectNameToTotalFunds;

	function addProject(
		string memory _name,
		uint256 _totalFundsInProject
	) public {
		listofProjects.push(Project(_name, _totalFundsInProject));
		projectNameToTotalFunds[_name] = _totalFundsInProject;
	}

	//getter fx

	function getProjectTotalFunds(
		string calldata _name
	) public view returns (uint256) {
		return projectNameToTotalFunds[_name];
	}
}
