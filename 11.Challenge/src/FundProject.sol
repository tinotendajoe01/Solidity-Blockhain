// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { PriceConvertor } from "./PriceConvertor.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error Project_Does_Not_Exist();
error Insuficient_Eth();

/**
 * @title A Funding contract for a crowdfunding app
 * @author Tinotenda Joe
 * @notice ///
 * @dev This implements price feeds AggregatorV3Interface from the Chainlink package
 */
contract FundProject is ProjectsStorage {
	using PriceConvertor for uint256;
	uint256 private constant MINIMUN_USD = 5e18;
	AggregatorV3Interface private s_priceFeed;

	constructor(address priceFeed) {
		s_priceFeed = AggregatorV3Interface(priceFeed);
	}

	function fund(string memory _name) public payable {
		uint256 projectId = projectNameToId[_name];

		if (projectId == 0) revert Project_Does_Not_Exist();
		// if (msg.value.getConversionRate(s_priceFeed) < MINIMUN_USD)
		// revert Insuficient_Eth();
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

	function getPriceFeed() public view returns (AggregatorV3Interface) {
		return s_priceFeed;
	}
}
