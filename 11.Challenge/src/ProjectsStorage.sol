// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
error ProjectsStorage__NotOwner();

contract ProjectsStorage {
	uint256 private constant INITIAL_BALANCE = 0;
	uint256 private projectIdCounter;
	address private immutable i_owner;

	constructor() {
		i_owner = msg.sender;
	}

	struct Project {
		uint256 id;
		string name;
		uint256 fundingGoal;
		uint256 totalFundsRaised;
		address[] funders;
	}
	modifier onlyOwner() {
		// Revert with custom error if the caller is not the owner
		if (msg.sender != i_owner) revert ProjectsStorage__NotOwner();
		_;
	}
	Project[] public listofProjects;
	mapping(string => uint256) public projectNameToId;

	function addProject(
		string memory _name,
		uint256 _fundingGoal
	) public onlyOwner {
		projectIdCounter++;
		listofProjects.push(
			Project(projectIdCounter, _name, _fundingGoal, 0, new address[](0))
		);
		projectNameToId[_name] = projectIdCounter;
	}

	// Getter function to retrieve the funders for a project
	function getProjectFunders(
		string calldata _name
	) public view returns (address[] memory) {
		uint256 projectId = projectNameToId[_name];
		require(projectId != 0, "Project does not exist");

		Project storage project = listofProjects[projectId - 1];
		return project.funders;
	}
}
