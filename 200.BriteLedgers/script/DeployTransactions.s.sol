// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Transactions} from "../src/Transactions.sol";
import {Script} from "forge-std/Script.sol";

contract DeployTransactions is Script {
    Transactions transactions;

    function run() public returns (Transactions) {
        vm.startBroadcast();
        transactions = new Transactions();
        vm.stopBroadcast();
        return transactions;
    }
}
