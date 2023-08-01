// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Transactions} from "../src/LedgerContracts/Transactions.sol";
import {Script} from "forge-std/Script.sol";

contract DeployTransactions is Script {
    address Owner = makeAddr("manufacturer");
    Transactions transactions;

    function run() public returns (Transactions) {
        vm.startBroadcast();
        transactions = new Transactions(Owner);
        vm.stopBroadcast();
        return transactions;
    }
}
