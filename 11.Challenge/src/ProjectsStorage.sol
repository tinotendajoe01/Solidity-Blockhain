// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
error ProjectsStorage__NotOwner();
error Project_Does_Not_Exist();
error Funding_Goal_CanntoBeLess_Than_Zero();
error Name_Exists();
error ProjectNam_CntBEmpty();

contract ProjectsStorage {
	uint256 private constant INITIAL_BALANCE = 0;
	uint256 public projectIdCounter;
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
		address projectAddress;
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
		address randomAddress = getUniqueAddress();
		if (_fundingGoal <= 0) revert Funding_Goal_CanntoBeLess_Than_Zero();
		if (projectNameAlreadyExists(_name) == true) revert Name_Exists();
		if (keccak256(bytes(_name)) == keccak256(bytes("")))
			revert ProjectNam_CntBEmpty();
		projectIdCounter++;
		listofProjects.push(
			Project(
				projectIdCounter,
				_name,
				_fundingGoal,
				0,
				new address[](0),
				randomAddress
			)
		);
		projectNameToId[_name] = projectIdCounter;
	}

	function projectNameAlreadyExists(
		string memory projectName
	) public view returns (bool) {
		for (uint256 i = 0; i < listofProjects.length; i++) {
			if (
				keccak256(bytes(listofProjects[i].name)) ==
				keccak256(bytes(projectName))
			) {
				return true;
			}
		}
		return false;
	}

	// Getter function to retrieve the funders for a project
	function getProjectFunders(
		string calldata _name
	) public view returns (address[] memory) {
		uint256 projectId = projectNameToId[_name];
		// require(projectId != 0, "Project does not exist");
		if (projectId != 0) revert Project_Does_Not_Exist();

		Project storage project = listofProjects[projectId - 1];
		return project.funders;
	}

	function checkGoalReached(string memory _name) public view returns (bool) {
		uint256 projectId = projectNameToId[_name];
		if (projectId == 0) revert Project_Does_Not_Exist();
		Project storage project = listofProjects[projectId - 1];
		return project.totalFundsRaised >= project.fundingGoal;
	}

	function getProjectId(
		string memory projectName
	) public view returns (uint256) {
		return projectNameToId[projectName];
	}

	function getProjectsLength() public view returns (uint256) {
		return listofProjects.length;
	}

	function getProject(
		uint256 projectId
	) public view returns (Project memory) {
		Project memory project = listofProjects[projectId - 1];
		return project;
	}

	function setProjectDetails(
		uint256 projectId,
		uint256 newTotalFundsRaised,
		address newFunder
	) public {
		Project storage project = listofProjects[projectId - 1];
		project.totalFundsRaised += newTotalFundsRaised;
		project.funders.push(newFunder);
	}

	function getUniqueAddress() public view returns (address) {
		return
			address(
				uint160(
					uint(
						keccak256(abi.encodePacked(block.timestamp, msg.sender))
					)
				)
			);
	}
}
