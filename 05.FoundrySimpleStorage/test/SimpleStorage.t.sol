// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { DeploySimpleStorage } from "../script/DeploySimpleStorage.s.sol";
import { SimpleStorage } from "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
	SimpleStorage public simpleStorage; // contract variable instance of type SimpleStorage contract

	function setUp() external {
		DeploySimpleStorage deployer = new DeploySimpleStorage();
		simpleStorage = deployer.run();
	}

	function testIsworking() public {
		//arrange
		uint256 cat;
		//act

		//assert
		assertEq(cat, 0);
	}
}
