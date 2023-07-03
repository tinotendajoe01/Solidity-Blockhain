// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Test } from "forge-std/Test.sol";
import { ProjectsStorage } from "../src/ProjectsStorage.sol";
import { DeployProjectsStorage } from "../script/DeployProjectsStorage.s.sol";

contract TestProjectsStorage is Test {
	ProjectsStorage projectsStorage;

	function setUp() external {
		DeployProjectsStorage deployer = new DeployProjectsStorage();
		projectsStorage = deployer.run();
	}
}
