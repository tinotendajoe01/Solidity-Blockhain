## WHAT IS FOUNDRY?

Foundry, a tool for managing dependencies, compiling projects, running tests, deploying contracts, and interacting with the Ethereum blockchain via command-line and Solidity scripts. The platform at https://book.getfoundry.sh/ is the documentation for Foundry, it provides a comprehensive guide on how to use Foundry for development, testing, and deployment of smart contracts.

## Installation

```
curl -L https://foundry.paradigm.xyz | bash
```

This will install `Foundryup`, then simply follow the instructions on-screen, which will make the foundryup command available in your CLI.

Running foundryup by itself will install the latest (nightly) precompiled binaries: `forge, cast, anvil, and chisel`. use `foundryup --help` for more options, like installing from a specific version or commit.

visit https://book.getfoundry.sh/getting-started/installation for more details about this tool

## FILE STRUCTURE

# 1.src

this folder contain all the start contracts in our case the SimplesStorage

# 2.tests

this folder contain all the test files and codes. unit test, integration test,staged tests.

# 3.lib

this is the library that contain dependencies

# 4.out

this is the output folder that contains files off the compiled or deployed contracts

# 5.script

In Foundry, the script folder is used to store scripts that automate tasks such as deploying smart contracts, interacting with the blockchain, and performing other custom operations. These scripts are written in Solidity and can be executed using Foundry's built-in commands.

One example of using a script in Foundry is deploying a smart contract. To deploy a smart contract, you can create a script file in the script folder, named Deploy.sol. This script file will contain the necessary Solidity code to deploy your smart contract to the blockchain. The script will typically import the contract you want to deploy and then instantiate it with the required constructor arguments.

## Tests

Unit tests, staged tests, and integration tests are different types of testing techniques that help ensure the correctness and reliability of your smart contracts in Solidity. These tests vary in scope and complexity, but all contribute to building robust and secure smart contracts.
`Unit Tests`
Unit tests are small, focused tests that check a small part of your contract for correctness. They are simple to write, quick to run, and let you add features and fix bugs in your code with confidence .

Example

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function increment() public {
        number++;
    }

    function setNumber(uint256 x) public {
        number = x;
    }
}
```

Now, we will create a unit test for this contract using Foundry's Forge testing framework. First, create a new file called `CounterTest.t.sol` and import the necessary files, including the `Counter.sol` contract and `forge-std/Test.sol` for the testing utilities.

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Counter.sol";
contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }
}
```

Now, we can write our unit tests for the increment() and setNumber(uint256 x) functions. For each test, create a public function with a name starting with test. In these functions, call the contract functions and use assertEq() to check if the expected values are correct. You can also add an optional error message as a third argument to the assertEq() function.

```
function testIncrement() public {
    counter.increment();
    assertEq(counter.number(), 1, "Expected number to be incremented to 1");
}

function testSetNumber(uint256 x) public {
    counter.setNumber(x);
    assertEq(counter.number(), x, "Expected number to be set to the given value");
}

```

```
To run the tests, use the following commands in the terminal, assuming you have Foundry installed:

forge init
forge test
```

This will initialize the Foundry environment, create tests, and run them for you. The output should show the results of the tests, indicating whether they passed or failed

`Staged Tests`
Staged tests, also known as integration tests, evaluate the components of a smart contract as a whole, detecting issues arising from cross-contract calls or interactions between different functions in the same smart contract .

To write an example of a staged or integration test using Foundry, let's consider a scenario where we have two smart contracts: Token.sol (an ERC20 token) and TokenSale.sol (a contract for selling tokens). We want to test the interaction between these two contracts.

First, let's create the Token.sol contract that implements a simple ERC20 token:

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}
```

Next, create the TokenSale.sol contract that allows users to buy our ERC20 tokens using Ether:

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Token.sol";

contract TokenSale {
    Token public token;
    uint256 public tokenPrice;

    constructor(Token _token, uint256 _tokenPrice) {
        token = _token;
        tokenPrice = _tokenPrice;
    }

    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * tokenPrice, "Incorrect Ether value sent");
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens available");

        token.transfer(msg.sender, amount);
    }
}
```

Now, let's create an integration test for these two contracts. Create a new file called `TokenSaleTest.t.sol` and import the necessary files, including the `Token.sol` and `TokenSale.sol` contracts, and `forge-std/Test.sol` for the testing utilities. Next, create a contract called `TokenSaleTest` that inherits from the `Test` contract. Define public variables for the Token and TokenSale contracts, and implement the `setUp()` function to deploy both contracts and set their initial state.

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/TokenSale.sol";
contract TokenSaleTest is Test {
    Token public token;
    TokenSale public tokenSale;

    function setUp() public {
        token = new Token(1000000);
        tokenSale = new TokenSale(token, 1 ether);
        token.transfer(address(tokenSale), 1000000);
    }
}
```

Now we can write our integration test for the `buyTokens(uint256 amount)` function. Create a public function with a name starting with test, and in this function, call the contract functions and use `assertEq()` to check if the expected values are correct. You can also add an optional error message as a third argument to the `assertEq()` function.

```
function testBuyTokens() public {
    uint256 initialTokenBalance = token.balanceOf(address(this));
    uint256 tokensToBuy = 10;

    tokenSale.buyTokens{value: tokensToBuy * 1 ether}(tokensToBuy);

    uint256 expectedTokenBalance = initialTokenBalance - tokensToBuy;
    assertEq(token.balanceOf(address(this)), expectedTokenBalance, "Expected token balance to decrease after buying tokens");
}
```

To run the tests, use the following commands in the terminal, assuming you have Foundry installed:

```
forge init
forge test
```
