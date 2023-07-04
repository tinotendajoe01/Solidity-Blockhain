// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { ProjectsStorage } from "./ProjectsStorage.sol";
import { PriceConvertor } from "./PriceConvertor.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { Randomness } from "./Randomness.sol";

error Project_Does_Not_Exist();
error Insuficient_Eth();

/**
 * @title A Funding contract for a crowdfunding app
 * @author Tinotenda Joe
 * @notice ///
 * @dev This implements price feeds AggregatorV3Interface from the Chainlink package, ERC721 NFTs from OpenZeppelin,
 *      and a random number generator contract.
 * */
contract FundProject is ProjectsStorage, ERC721 {
	using PriceConvertor for uint256;
	using SafeMath for uint256;

	uint256 private constant MINIMUM_USD = 5e18;
	AggregatorV3Interface private s_priceFeed;
	uint256 private raffleTokenIdCounter;
	mapping(uint256 => string) private raffleTokenIdToMetadata;
	mapping(uint256 => uint256) private projectIdToFundingGoal;
	mapping(uint256 => address[]) private projectIdToFunders;
	mapping(uint256 => uint256) private projectIdToTotalFundsRaised;
	mapping(uint256 => bool) private projectIdToRaffleStatus;
	Randomness private randomness;

	constructor(
		address priceFeed,
		address _randomness
	) ERC721("RaffleNFT", "RNFT") {
		s_priceFeed = AggregatorV3Interface(priceFeed);
		randomness = Randomness(_randomness);
	}

	function fund(string memory _name) public payable {
		uint256 projectId = projectNameToId[_name];

		if (projectId == 0) revert Project_Does_Not_Exist();
		if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD)
			revert Insufficient_Eth();

		Project storage project = listofProjects[projectId - 1];
		project.totalFundsRaised = project.totalFundsRaised.add(msg.value);
		project.funders.push(msg.sender);

		projectIdToFunders[projectId].push(msg.sender);
		projectIdToTotalFundsRaised[projectId] = project.totalFundsRaised;

		// Check if the funding goal is reached
		if (
			project.totalFundsRaised >= project.fundingGoal &&
			!projectIdToRaffleStatus[projectId]
		) {
			projectIdToRaffleStatus[projectId] = true;
			conductRaffle(projectId);
		}

		// Mint raffle NFT for the funder
		uint256 tokenId = mintRaffleNFT(msg.sender);
		projectRaffleTokens[projectId].push(tokenId);
	}

	function generateRandomMetadata() internal view returns (string memory) {
		// Implement your logic to generate random metadata for the NFT
		// This can include name, description, image URL, etc.
		// For simplicity, let's return a fixed metadata string in this example
		return "Random NFT Metadata";
	}

	function conductRaffle(uint256 projectId) internal {
		address[] storage funders = projectIdToFunders[projectId];
		uint256 totalFunders = funders.length;

		if (totalFunders > 0) {
			uint256 winningIndex = randomness.getRandomNumber(totalFunders);
			address winner = funders[winningIndex];

			// Transfer the NFT to the winner
			uint256 tokenId = projectRaffleTokens[projectId][winningIndex];
			_transfer(address(this), winner, tokenId);
		}
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
