// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { PriceConvertor } from "./PriceConvertor.sol";

error Project_Does_Not_Exist();
error Insufficient_Eth();

contract FundProject is ProjectsStorage {
	using PriceConvertor for uint256;
	uint256 public constant MINIMUM_USD = 5e18;
	AggregatorV3Interface private s_priceFeed;

	constructor(address priceFeed) {
		s_priceFeed = AggregatorV3Interface(priceFeed);
	}

	function fund(string memory _name, uint256 _amount) public payable {
		if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD)
			revert Insufficient_Eth();

		// Get the project ID using the project name
		uint256 projectId = projectNameToId[_name];
		if (projectId == 0) revert Project_Does_Not_Exist();
		Project storage project = listofProjects[projectId - 1];
		project.totalFundsRaised += _amount;
		project.funders.push(msg.sender);
	}

	function getProjectBalance(
		string memory _name
	) public view returns (uint256) {
		uint256 projectId = projectNameToId[_name];
		if (projectId == 0) revert Project_Does_Not_Exist();
		Project storage project = listofProjects[projectId - 1];
		return project.totalFundsRaised;
	}

	function getPriceFeed() public view returns (AggregatorV3Interface) {
		return s_priceFeed;
	}
}
