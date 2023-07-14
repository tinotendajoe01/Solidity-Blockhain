# Reentrancy in Smart Contracts

Reentrancy is a type of attack that can occur in smart contracts that allow untrusted external code to be executed within the contract. This can happen when a smart contract calls an external contract, and the external contract then calls back into the original contract, potentially causing an infinite loop geeksforgeeks.org.

Reentrancy attacks have been a critical issue in smart contract development, as they can lead to loss of funds, compromise the integrity of smart contracts, and cause systemic failures. Therefore, it’s important to be aware of the potential vulnerabilities and take steps to prevent them geeksforgeeks.org.

## Examples of Reentrancy Attacks

DAO Hack: The DAO (Decentralized Autonomous Organization) smart contract was a decentralized investment fund built on the Ethereum blockchain. An attacker discovered a vulnerability in the DAO smart contract that allowed them to repeatedly call the “split” function, which allowed investors to withdraw their funds from the DAO before the contract had a chance to update the internal balances. The attacker was able to use this vulnerability to repeatedly call the split function and drain the DAO of approximately $50 million worth of Ether (ETH) geeksforgeeks.org.

Lendf.me Protocol: In 2019 an attacker discovered a vulnerability in the smart contract that allowed them to repeatedly borrow and repay the same loan over and over again, while also manipulating the price of the underlying assets to increase the amount of the loan. The attacker was able to exploit this vulnerability to borrow and repay a single loan multiple times, stealing more than $350,000 worth of cryptocurrency assets from the platform geeksforgeeks.org.

## Code Example of a Reentrancy Attack

Here is a simple example of a smart contract that is vulnerable to reentrancy attacks:

```
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
/// @title A contract for demonstrate payable functions and addresses
/// @author Jitendra Kumar
/// @notice For now, this contract just show how payable functions and addresses can receive ether into the contract
contract Reentrancy {
    mapping(address => uint) public balance;

    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw() public payable {
        require(balance[msg.sender] >= msg.value);
        payable(msg.sender).transfer(msg.value);
        balance[msg.sender] -= msg.value;
    }
}

```

In this contract, the deposit function allows users to deposit funds into their account and the withdraw function allows users to withdraw their deposited funds. However, the contract does not properly check for reentrancy, so an attacker could create a malicious contract that repeatedly calls the deposit function before calling the withdraw function, effectively stealing funds from the contract geeksforgeeks.org.

## Preventing Reentrancy Attacks

One way to prevent reentrancy attacks is to use a mutex, or mutual exclusion, lock to prevent multiple calls to the same function from occurring at the same time. Another way is to use a guard condition, where a flag is set before external function calls and checked after geeksforgeeks.org.

```
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
/// @title A contract for demonstrate Reentrancy Attack
/// @author Jitendra Kumar
/// @notice For now, this contract just show how to protect Smart Contracts against a Reentrancy Attack
contract Reentrancy {

    mapping(address => uint) public balance;
    bool public reentrancyLock;

    function deposit() public payable {
        require(!reentrancyLock);
        reentrancyLock = true;
        balance[msg.sender] += msg.value;
        reentrancyLock = false;
    }

    function withdraw() public payable{
        require(balance[msg.sender] >= msg.value);
        payable(msg.sender).transfer(msg.value);
        balance[msg.sender] -= msg.value;
    }
}
```

In this example, a reentrancyLock variable is added to the contract. The deposit function now checks if the reentrancyLock variable is true before allowing the deposit to occur. If the variable is true, the deposit will not occur and the attacker will not be able to steal funds. The reentrancyLock variable is

## Examples of Reentrancy Attacks

The most infamous example of reentrancy attack is the DAO Hack. DAO was a decentralized funding vehicle. Due to a reentrancy vulnerability, attackers were able to continuously call the "split" function to retrieve more Ether than was initially invested.

Here's an oversimplified version of DAO's split() function:

```
function splitDAO(uint _proposalId, address _newCurator) external {
    // Some code here

    // Then the calling user's ether balance gets updated
    balances[_newCurator] = balanceOf(msg.sender);

    // Ether gets sent to the calling user's address
    withdrawEther(rewardToken[msg.sender]);

    ...
}
```

The hacker initiated a splitDAO request, and during the execution, called another splitDAO request - re-entering before the function finished executing.

## How to Prevent Reentrancy Attacks

To prevent any form of reentrancy, the checks-effects-interactions pattern is encouraged and the reentrancy guard is used.

Here's the same function, written with the check-effects-interactions pattern:

```
mapping(address => uint) private userBalance;

function withdrawBalance() public {
    uint amountToSend = userBalance[msg.sender];

    // Checks
    require(amountToSend > 0);

    // Effects
    userBalance[msg.sender] = 0;

    // Interactions
    require(msg.sender.call.value(amountToSend)());

    // If the transfer fails (i.e., throw), the state change will be reverted
}
```

As per this pattern, checks (such as ensuring that the balance is adequate) and changes to the contract's state are processed before the contract interacts (sends the amount to the user) with another contract.

Lastly, employing OpenZeppelin’s ReentrancyGuard offers another layer of security:

```
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract MyContract is ReentrancyGuard {
    uint256 public amount;

    function withdraw() public nonReentrant { // here is the modifier
        (bool transferSucceeded,) = msg.sender.call{value:amount}("");
        if (transferSucceeded) {
            amount = 0;
        }
    }
}
```

The nonReentrant modifier ensures that the withdraw function cannot be re-entered while the msg.sender.transfer is not fully completed.

Through understanding reentrancy attacks, the check/effects/interactions pattern, and reentrancy guards, you can more effectively secure smart contracts against reentrancy vulnerabilities.

## Preventing Reentrancy Attacks

### Programming Patterns

Checks-Effects-Interactions Pattern: This pattern improves contract robustness and provides protection against reentrancy attacks. It ensures that all state checks and updates are completed before any external interactions occur.

### Protective Measures

Mutex Locks: A Mutex is a mutually exclusive flag that locks the contract state during the execution of a vulnerable function.
Reentrancy Guards: The "nonReentrant" modifier ensures that certain functions cannot be re-entered while they're not fully completed.

### Important Concepts to Master

Cross-Contract Reentrancy: This type refers to interactions that involve unpredictable external contract behaviors. Proper adherence to the Checks-Effects-Interactions pattern can effectively mitigate this type of reentrancy.
Security Audits: Audits boost the confidence level of users in a blockchain environment. They aim to secure contracts and foster trust among users.
Vulnerability Detection Tools: These tools allow detection of potential vulnerabilities even before the deployment of smart contracts. Examples of such tools include SmartCheck, Remix, Oyente, and Mythril.
Execution Stage Security: Given the immutable nature of blockchain technology, it's fundamental to address security flaws during the execution stage.
