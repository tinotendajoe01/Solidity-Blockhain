// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { PriceConvertor } from "./PriceConvertor.sol";
import { FundRaffleMoodNft } from "./FundRaffleNft.sol";

error Project_Does_Not_Exist();
error Insufficient_Eth();

contract FundProject {
	using PriceConvertor for uint256;
	uint256 public constant MINIMUM_USD = 5e18;

	AggregatorV3Interface private s_priceFeed;
	// NFT Minting contract
	FundRaffleMoodNft private raffleMOODNFT;
	ProjectsStorage private projectsStorage;

	constructor(
		address priceFeed,
		address raffleMOODNFTAddress,
		address projectsStorageAddress
	) {
		s_priceFeed = AggregatorV3Interface(priceFeed);
		raffleMOODNFT = FundRaffleMoodNft(raffleMOODNFTAddress);
		projectsStorage = ProjectsStorage(projectsStorageAddress);
	}

	function fund(string memory _name, uint256 _amount) public payable {
		if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD)
			revert Insufficient_Eth();

		// Get the project ID using the project name
		uint256 projectId = projectsStorage.getProjectId(_name);
		if (projectId == 0) revert Project_Does_Not_Exist();
		ProjectsStorage.Project memory project = getProjectDetails(projectId);
		// project.totalFundsRaised += _amount;
		// project.funders.push(msg.sender);
		projectsStorage.setProjectDetails(projectId, _amount, msg.sender);

		// Call the mintNft function of the FundRaffleMoodNft contract
		raffleMOODNFT.mintNft(project.projectAddress);
	}

	function getProjectBalance(
		string memory _name
	) public view returns (uint256) {
		uint256 projectId = projectsStorage.getProjectId(_name);
		if (projectId == 0) revert Project_Does_Not_Exist();
		ProjectsStorage.Project memory project = getProjectDetails(projectId);
		return project.totalFundsRaised;
	}

	function getPriceFeed() public view returns (AggregatorV3Interface) {
		return s_priceFeed;
	}

	function getProjectDetails(
		uint256 projectId
	) public view returns (ProjectsStorage.Project memory) {
		ProjectsStorage.Project memory project = projectsStorage.getProject(
			projectId
		);
		return project;
	}
}
