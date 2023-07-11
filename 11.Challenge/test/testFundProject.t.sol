// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { DeployFundProject } from "../script/DeployFundProject.s.sol";
import { FundProject } from "../src/FundProject.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

contract TestFundProject is Test {
	FundProject fundProject;
	HelperConfig public helperConfig;
	uint256 public constant AMOUNT = 0.2 ether;
	uint256 public constant STARTING_FUNDER_BALANCE = 10 ether;
	uint256 public constant GAS_PRICE = 1;
	address public constant FUNDER = address(1);

	function setUp() external {
		DeployFundProject deployer = new DeployFundProject();
		(fundProject, helperConfig) = deployer.run();
		vm.deal(FUNDER, STARTING_FUNDER_BALANCE);
	}

	function testPriceFeedSetCorrectly() public {
		address retreivedPriceFeed = address(fundProject.getPriceFeed());

		address expectedPriceFeed = helperConfig.activeNetworkConfig();
		assertEq(retreivedPriceFeed, expectedPriceFeed);
	}

	function testCanFundProject() public {
		vm.startPrank(msg.sender);
		fundProject.addProject("Sushi", 500);
		vm.stopPrank();
		vm.startPrank(FUNDER);
		fundProject.fund{ value: AMOUNT }("Sushi", AMOUNT);
		vm.stopPrank();
		uint256 endingUserBalance = FUNDER.balance;
		console.log(endingUserBalance);
		uint256 expectedTotalFunds = AMOUNT;
		uint256 actualTotalFunds = fundProject.getProjectBalance("Sushi");
		assertEq(expectedTotalFunds, actualTotalFunds);
	}
}
