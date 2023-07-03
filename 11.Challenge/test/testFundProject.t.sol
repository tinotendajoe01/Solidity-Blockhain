// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { DeployFundProject } from "../script/DeployFundProject.s.sol";
import { FundProject } from "../src/FundProject.sol";

contract TestFundProject is Test {
	FundProject fundProject;
	uint256 public constant AMOUNT = 70; // just a value to make sure we are sending enough!

	address public constant FUNDER = address(1);

	function setUp() external {
		DeployFundProject deployer = new DeployFundProject();
		fundProject = deployer.run();
		vm.deal(FUNDER, AMOUNT);
	}

	function testCanFundProject() public {
		vm.prank(msg.sender);
		fundProject.addProject("Sushi", 500);
		vm.prank(FUNDER);
		fundProject.fund{ value: AMOUNT }("Sushi");

		uint256 expectedTotalFunds = AMOUNT;
		uint256 actualTotalFunds = fundProject.projectBalance("Sushi");
		assertEq(expectedTotalFunds, actualTotalFunds);
	}
}
