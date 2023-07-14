// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Test, console } from "forge-std/Test.sol";

import { ProjectsStorage } from "../src/ProjectsStorage.sol";
import { DeployProjectsStorage } from "../script/DeployProjectsStorage.s.sol";

contract TestProjectsStorage is Test {
	ProjectsStorage projectsStorage;

	function setUp() external {
		DeployProjectsStorage deployer = new DeployProjectsStorage();
		projectsStorage = deployer.run();
	}

	function testOnlyOwnerCanAddProject() public {
		vm.expectRevert(); //must fail not owner
		// vm.prank(msg.sender); //user owner addres
		projectsStorage.addProject("Football", 400);
	}

	function testProjectIsCreatedWithUniqueidAndAddedToListOfProjects() public {
		vm.startPrank(msg.sender);
		projectsStorage.addProject("Football", 400);
		projectsStorage.addProject("Basketball", 500);
		projectsStorage.addProject("Tennis", 600);
		uint256 expectedId = 3;
		uint256 actualId = projectsStorage.projectIdCounter();
		uint256 expectedLenght = 3;
		uint256 actualLength = projectsStorage.getProjectsLength();

		assertEq(expectedId, actualId);
		assertEq(expectedLenght, actualLength);
	}

	function testProjectNameMappedToId() public {
		vm.startPrank(msg.sender);
		projectsStorage.addProject("Football", 400);
		projectsStorage.addProject("Basketball", 500);
		projectsStorage.addProject("Tennis", 600);
		uint256 basketballId = 2;
		uint256 actualBasketBallId = projectsStorage.projectNameToId(
			"Basketball"
		);
		assertEq(basketballId, actualBasketBallId);
	}

	function testProjectCannotBeCreatedWithZeroFundingBalance() public {
		vm.expectRevert(); //must fail no goal

		projectsStorage.addProject("Football", 0);
	}

	function testProjectIsNotCreatedWithDuplicateName() public {
		vm.startPrank(msg.sender);
		projectsStorage.addProject("Football", 400);
		vm.expectRevert();
		projectsStorage.addProject("Football", 500);

		vm.expectRevert();
		projectsStorage.addProject("", 500);
	}
}
