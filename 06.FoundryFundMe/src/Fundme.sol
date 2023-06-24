// SPDX-License-Identifier: MIT
// 1. Pragma
// Specify the compiler version required for this contract
pragma solidity ^0.8.20;

// 2. Imports
// Import AggregatorV3Interface from the Chainlink package
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// Import PriceConverter from a local file
import { PriceConverter } from "./PriceConverter.sol";

// 3. Interfaces, Libraries, Contracts
// Custom error for the onlyOwner modifier
error FundMe__NotOwner();

/**
 * @title A sample Funding Contract
 * @author Tinotenda Joe
 * @notice This contract is for creating a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
	// Type Declarations
	// Use the PriceConverter library for uint256 type
	using PriceConverter for uint256;

	// State variables
	// Define a constant for the minimum USD amount required for funding
	uint256 public constant MINIMUM_USD = 5e18;
	// Immutable variable to store the contract owner's address
	address private immutable i_owner;
	// Array to store the addresses of funders
	address[] private s_funders;
	// Mapping to store the amount funded by each address
	mapping(address => uint256) private s_addressToAmountFunded;
	// Instance of the AggregatorV3Interface for the price feed
	AggregatorV3Interface private s_priceFeed;

	// Modifiers
	// Modifier to ensure a function is only called by the contract owner
	modifier onlyOwner() {
		// Revert with custom error if the caller is not the owner
		if (msg.sender != i_owner) revert FundMe__NotOwner();
		_;
	}
	struct Funder {
		address funderAddress;
		uint256 fundedAmount;
	}

	Funder[] public s_fundersInfo;

	// Constructor
	// Initialize the contract with the price feed address
	constructor(address priceFeed) {
		// Set the price feed instance
		s_priceFeed = AggregatorV3Interface(priceFeed);
		// Set the contract owner to the address deploying the contract
		i_owner = msg.sender;
	}

	/// @notice Funds our contract based on the ETH/USD price
	// Function to fund the contract
	function fund() public payable {
		// Check if the amount of ETH sent is enough based on the current conversion rate
		require(
			msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
			"You need to spend more ETH!"
		);
		// Update the amount funded by the sender's address
		s_addressToAmountFunded[msg.sender] += msg.value;
		// Add the sender's address to the funders array
		s_funders.push(msg.sender);
		s_fundersInfo.push(
			Funder({ funderAddress: msg.sender, fundedAmount: msg.value })
		);
	}

	// Function to withdraw funds by the owner
	function withdraw() public onlyOwner {
		// Loop through the funders array and reset their funded amounts
		for (
			uint256 funderIndex = 0;
			funderIndex < s_funders.length;
			funderIndex++
		) {
			address funder = s_funders[funderIndex];
			s_addressToAmountFunded[funder] = 0;
		}
		// Clear the funders array
		s_funders = new address[](0);
		// Transfer the contract balance to the owner
		(bool success, ) = i_owner.call{ value: address(this).balance }("");
		require(success);
	}

	// Alternative function to withdraw funds with a cheaper gas cost
	function cheaperWithdraw() public onlyOwner {
		// Create a memory array of funders to save gas
		address[] memory funders = s_funders;
		// Loop through the funders array and reset their funded amounts
		for (
			uint256 funderIndex = 0;
			funderIndex < funders.length;
			funderIndex++
		) {
			address funder = funders[funderIndex];
			s_addressToAmountFunded[funder] = 0;
		}
		// Clear the funders array
		s_funders = new address[](0);
		// Transfer the contract balance to the owner
		(bool success, ) = i_owner.call{ value: address(this).balance }("");
		require(success);
	}

	/**
	 * @notice Gets the amount that an address has funded
	 *  @param fundingAddress the address of the funder
	 *  @return the amount funded
	 */
	// Function to get the amount funded by a specific address
	function getAddressToAmountFunded(
		address fundingAddress
	) public view returns (uint256) {
		return s_addressToAmountFunded[fundingAddress];
	}

	// Functions to view the states in  the blockchain

	function getVersion() public view returns (uint256) {
		return s_priceFeed.version();
	}

	function getFunder(uint256 index) public view returns (address) {
		return s_funders[index];
	}

	function getOwner() public view returns (address) {
		return i_owner;
	}

	function getPriceFeed() public view returns (AggregatorV3Interface) {
		return s_priceFeed;
	}

	function getTotalFundedAmount() public view returns (uint256) {
		uint256 totalFundedAmmount = 0;

		for (
			uint256 funderIndex;
			funderIndex < s_funders.length;
			funderIndex++
		) {
			address funder = s_funders[funderIndex];
			totalFundedAmmount += s_addressToAmountFunded[funder];
		}
		return totalFundedAmmount;
	}

	function getFundersList() public view returns (address[] memory) {
		return s_funders;
	}

	function getFundersInfo() public view returns (Funder[] memory) {
		return s_fundersInfo;
	}

	/**
	 * @notice Allows a funder to refund their contributed funds
	 * @dev Refunds the sender's funded amount, removes the sender from the s_funders array, and transfers the funds back to the sender
	 */
	function refund() public {
		// Get the funded amount of the sender.
		uint256 fundedAmount = s_addressToAmountFunded[msg.sender];
		// Require that the sender has funded the contract before proceeding.
		require(fundedAmount > 0, "You have not funded this contract.");

		// Set the sender's funded amount in the mapping to zero, effectively removing their contribution.
		s_addressToAmountFunded[msg.sender] = 0;

		// Loop through the s_funders array to find and remove the sender's address.
		for (uint256 i = 0; i < s_funders.length; i++) {
			// If the sender's address is found, remove it from the s_funders array.
			if (s_funders[i] == msg.sender) {
				// Replace the sender's address with the last address in the s_funders array.
				s_funders[i] = s_funders[s_funders.length - 1];
				// Remove the last address from the s_funders array, effectively removing the sender's address.
				s_funders.pop();
				// Break the loop, as the sender's address has been removed.
				break;
			}
		}

		// Transfer the funded amount back to the sender.
		(bool success, ) = msg.sender.call{ value: fundedAmount }("");
		// Require that the transfer was successful.
		require(success, "Refund failed.");
	}

	/**
	 * @notice Distributes a percentage of the total collected funds to all funders based on their contributions
	 * @param distributionPercentage The percentage of the total funds to be distributed (between 1 and 100)
	 * @dev Only callable by the contract owner, calculates each funder's share based on their contribution and transfers the corresponding amount to their address
	 */
	function distributeFunds(uint256 distributionPercentage) public onlyOwner {
		// Require that the distribution percentage is valid (between 1 and 100).
		require(
			distributionPercentage > 0 && distributionPercentage <= 100,
			"Invalid distribution percentage."
		);

		// Get the total funded amount from the getTotalFundedAmount function.
		uint256 totalFundedAmount = getTotalFundedAmount();
		// Calculate the distribution amount based on the total funded amount and the distribution percentage.
		uint256 distributionAmount = (totalFundedAmount *
			distributionPercentage) / 100;

		// Loop through the s_funders array to distribute the funds to each funder.
		for (uint256 i = 0; i < s_funders.length; i++) {
			// Get the funder's address from the s_funders array.
			address funder = s_funders[i];
			// Get the funder's contribution from the s_addressToAmountFunded mapping.
			uint256 funderContribution = s_addressToAmountFunded[funder];
			// Calculate the funder's share based on their contribution and the distribution amount.
			uint256 funderShare = (distributionAmount * funderContribution) /
				totalFundedAmount;

			// If the funder's share is greater than zero, transfer the share to the funder.
			if (funderShare > 0) {
				// Transfer the funder's share to their address.
				(bool success, ) = funder.call{ value: funderShare }("");
				// Require that the transfer was successful.
				require(success, "Fund distribution failed.");
			}
		}
	}
}
