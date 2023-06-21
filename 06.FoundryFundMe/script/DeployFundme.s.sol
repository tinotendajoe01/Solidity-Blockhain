// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import { Script } from "forge-std/Script.sol";
import { FundMe } from "../src/Fundme.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployFundme is Script {
    function run() external returns (FundMe) {
        //befor startBroadcast -- not a real tx / mock tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        //afta --real tx

        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
