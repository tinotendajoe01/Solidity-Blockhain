// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/Fundme.sol";

contract FundmeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMesgSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testHasDeadlinePassed() public {
        assertEq(fundMe.hasDeadlinePassed(), false, "Deadline check result should match expected result");
    }
}
