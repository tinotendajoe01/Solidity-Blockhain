// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {Gas} from "../src/gas.sol";
import {DeployGas} from "../script/DeployGas.s.sol";

contract GasTest is Test {
    DeployGas public deployer;
    Gas public gas;

    function setUp() public {
        deployer = new DeployGas();
        gas = deployer.run();
    }

    function testExhaustGas() public {
        gas.forever();
    }
}
