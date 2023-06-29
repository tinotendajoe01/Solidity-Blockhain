// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { OurToken } from "../src/OurToken.sol";
import { DeployOurToken } from "../script/DeployOurToken.s.sol";

contract TokenTest is Test {
	OurToken public ourToken;
	DeployOurToken public deployer;

	address joe = makeAddr("joe");
	address tatenda = makeAddr("tatenda");
	uint256 public constant STARTING_BALANCE = 100 ether;

	function setUp() public {
		deployer = new DeployOurToken();
		ourToken = deployer.run();

		vm.prank(msg.sender);

		ourToken.transfer(joe, STARTING_BALANCE);
	}

	function testJoeBalance() public {
		assertEq(STARTING_BALANCE, ourToken.balanceOf(joe));
	}

	function testAllowancesWork() public {
		uint256 initialAllowance = 1000;
		//joe approves Tate to spend tokens on her behalf
		vm.prank(joe);
		ourToken.approve(tatenda, initialAllowance);
		uint256 transferAmount = 500;
		vm.prank(tatenda);
		ourToken.transferFrom(joe, tatenda, transferAmount);
		assertEq(ourToken.balanceOf(tatenda), transferAmount);
		assertEq(ourToken.balanceOf(joe), STARTING_BALANCE - transferAmount);
	}
}
