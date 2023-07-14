// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { PriceConvertor } from "./PriceConvertor.sol";
import { FundRaffleMoodNft } from "./FundRaffleNft.sol";

error Project_Does_Not_Exist();
error Insufficient_Eth();

contract FundProject is ProjectsStorage {
	using PriceConvertor for uint256;
	uint256 public constant MINIMUM_USD = 5e18;
	AggregatorV3Interface private s_priceFeed;
	// NFT Minting contract
	FundRaffleMoodNft private raffleMOODNFT;

	constructor(address priceFeed, address raffleMOODNFTAddress) {
		s_priceFeed = AggregatorV3Interface(priceFeed);
		raffleMOODNFT = FundRaffleMoodNft(raffleMOODNFTAddress);
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
		// Call the mintNft function of the FundRaffleMoodNft contract
		raffleMOODNFT.mintNft(project.projectAddress);
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
