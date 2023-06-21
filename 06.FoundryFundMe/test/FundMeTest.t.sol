// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Test, console } from "forge-std/Test.sol";

contract FundmeTest is Test {
    uint256 number = 3;

    function setUp() external {
        number = 2;
    }

    function testDemo() public {
        console.log(number);
        assertEq(number, 2);
    }
}
