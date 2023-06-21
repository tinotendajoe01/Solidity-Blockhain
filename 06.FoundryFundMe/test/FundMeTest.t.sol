// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/Fundme.sol";
import { DeployFundme } from "../script/DeployFundme.s.sol";

contract FundmeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundme deployFundMe = new DeployFundme();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMesgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testHasDeadlinePassed() public {
        assertEq(fundMe.hasDeadlinePassed(), false, "Deadline check result should match expected result");
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
