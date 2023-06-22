// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { PriceConverter } from "./PriceConverter.sol";

// A custom error to be thrown if a non-owner tries to execute a function
error NotOwner();

// FundMe contract definition
contract FundMe {
	using PriceConverter for uint256;

	// A mapping to keep track of how much each funder has funded
	mapping(address => uint256) public addressToAmountFunded;

	// An array to keep track of all funders
	address[] public funders;

	// Address to which the funds will be sent
	address payable public fundsDestination;

	// Immutable contract owner
	address public i_owner;

	// Minimum amount that can be funded in USD
	uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

	// Maximum goal for the funding campaign
	uint256 public maxGoal;

	// Deadline for the funding campaign
	uint256 public deadline;

	// Event to be emitted when new funds are donated
	event NewDonation(address indexed funder, uint256 amount);

	// Constructor to set the contract owner to the deployer
	constructor() {
		i_owner = msg.sender;
	}

	// Struct to store the details of a funder
	struct Funder {
		address funderAddress;
		uint256 amountFunded;
	}

	// Function to set the maximum goal for the funding campaign
	function setMaxGoal(uint256 _maxGoal) public onlyOwner {
		maxGoal = _maxGoal;
	}

	// Function to set the deadline for the funding campaign
	function setDeadline(uint256 _deadline) public onlyOwner {
		deadline = _deadline;
	}

	// Function to fund the contract
	function fund() public payable {
		// Check that the amount of ETH being sent is at least the minimum amount in USD
		require(
			msg.value.getConversionRate() >= MINIMUM_USD,
			"You need to spend more ETH!"
		);

		// Check that the maximum goal has not been reached yet
		if (maxGoal > 0) {
			require(
				address(this).balance + msg.value <= maxGoal,
				"Maximum goal reached!"
			);
		}

		// Check if the deadline has passed
		if (deadline > 0) {
			require(
				block.timestamp <= deadline,
				"Deadline has passed, cannot fund!"
			);
		}

		// Update the mapping with the amount funded by the sender
		addressToAmountFunded[msg.sender] += msg.value;

		// Add the sender to the list of funders
		funders.push(msg.sender);

		// Transfer the funds to the destination address if the maximum goal is reached
		if (maxGoal > 0 && address(this).balance == maxGoal) {
			fundsDestination.transfer(address(this).balance);
		}

		// Emit the NewDonation event
		emit NewDonation(msg.sender, msg.value);
	}

	// Function to get the version of the Chainlink price feed being used
	function getVersion() public view returns (uint256) {
		AggregatorV3Interface priceFeed = AggregatorV3Interface(
			0x694AA1769357215DE4FAC081bf1f309aDC325306
		);
		return priceFeed.version();
	}

	// Function to check if the deadline has passed
	function hasDeadlinePassed() public view returns (bool) {
		return (deadline > 0 && block.timestamp > deadline);
	}

	// Modifier to ensure that only the owner can execute certain functions
	modifier onlyOwner() {
		if (msg.sender != i_owner) revert NotOwner();
		_;
	}

	// Function to withdraw the funds from the contract
	function withdraw() public onlyOwner {
		// Reset the funded amount for each funder
		for (
			uint256 funderIndex = 0;
			funderIndex < funders.length;
			funderIndex++
		) {
			address funder = funders[funderIndex];
			addressToAmountFunded[funder] = 0;
		}
		// Clear the list of funders
		funders = new address[](0);

		// Transfer the contract balance to the owner
		(bool callSuccess, ) = payable(msg.sender).call{
			value: address(this).balance
		}("");
		require(callSuccess, "Call failed");
	}

	// Function to set the destination address for the funds
	function setFundsDestination(
		address payable _fundsDestination
	) public onlyOwner {
		fundsDestination = _fundsDestination;
	}

	// Function to get the contract balance
	function getContractBalance() public view returns (uint256) {
		return address(this).balance;
	}

	// Function to get the contract balance
	function getContractBalance() public view returns (uint256) {
		// Return the balance of the contract
		return address(this).balance;
	}

	// Function to allow a funder to withdraw their funds
	function withdrawFunds() public {
		// Check if the maximum goal has been reached
		if (maxGoal > 0) {
			require(
				address(this).balance < maxGoal,
				"Max balance reached, cannot withdraw funds"
			);
		}

		// Get the amount funded by the sender
		uint256 amountFunded = addressToAmountFunded[msg.sender];

		// Check if the sender has funded any amount
		require(amountFunded > 0, "Sender has not funded any amount");

		// Reset the amount funded by the sender
		addressToAmountFunded[msg.sender] = 0;

		// Remove the sender from the list of funders
		for (
			uint256 funderIndex = 0;
			funderIndex < funders.length;
			funderIndex++
		) {
			if (funders[funderIndex] == msg.sender) {
				funders[funderIndex] = funders[funders.length - 1];
				funders.pop();
				break;
			}
		}

		// Transfer the amount funded back to the sender
		payable(msg.sender).transfer(amountFunded);
	}

	// Function to get the list of all donations
	function getDonations() public view returns (Funder[] memory) {
		// Create a new array of Funder structs to store the donations
		Funder[] memory donations = new Funder[](funders.length);

		// Iterate through the list of funders and populate the donations array
		for (uint256 i = 0; i < funders.length; i++) {
			address funder = funders[i];
			uint256 amount = addressToAmountFunded[funder];
			donations[i] = Funder(funder, amount);
		}

		// Return the list of donations
		return donations;
	}

	// Explainer from: https://solidity-by-example.org/fallback/
	// Ether is sent to contract
	//      is msg.data empty?
	//          /   \
	//         yes  no
	//         /     \
	//    receive()?  fallback()
	//     /   \
	//   yes   no
	//  /        \
	//receive()  fallback()

	// Fallback function called when the contract receives ETH without any data
	fallback() external payable {
		// Call the fund() function to process the received ETH
		fund();
	}

	// Receive function called when the contract receives ETH without any data and receive() is defined
	receive() external payable {
		// Call the fund() function to process the received ETH
		fund();
	}
}
