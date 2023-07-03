// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { DeployFundProject } from "../script/DeployFundProject.s.sol";
import { FundProject } from "../src/FundProject.sol";

contract TestFundProject is Test {
	FundProject fundProject;
	uint256 public constant AMOUNT = 70;

	address public constant FUNDER = address(1);

	function setUp() external {
		DeployFundProject deployer = new DeployFundProject();
		fundProject = deployer.run();
		vm.deal(FUNDER, AMOUNT);
	}

	function testCanFundProject() public {
		vm.startPrank(msg.sender);
		fundProject.addProject("Sushi", 500);

		vm.stopPrank();
		vm.startPrank(FUNDER);
		fundProject.fund{ value: 2 }("Sushi");
		fundProject.fund{ value: 2 }("Sushi");
		vm.stopPrank();
		uint256 endingUserBalance = FUNDER.balance;
		console.log(endingUserBalance);

		uint256 expectedTotalFunds = 4;
		uint256 actualTotalFunds = fundProject.projectBalance("Sushi");
		assertEq(expectedTotalFunds, actualTotalFunds);
	}
}
