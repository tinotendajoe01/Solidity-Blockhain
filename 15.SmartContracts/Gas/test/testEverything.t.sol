// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Everything} from "../src/everything.sol";
import {DeployEverything} from "../script/DeployEverything.s.sol";

contract EverythingTest is Test {
    DeployEverything public deployer;
    Everything public everything;

    function setUp() public {
        deployer = new DeployEverything();
        everything = deployer.run();
    }

    function testGet() public {
        assertEq(uint256(everything.get()), 0);
    }

    function testSet() public {
        // Use the Everything.Status enum directly
        everything.set(Everything.Status.Shipped);
        assertEq(uint256(everything.get()), 1);
    }

    function testCancel() public {
        everything.cancel();
        assertEq(uint256(everything.get()), 4);
    }

    struct TodoItem {
        string text;
        bool completed;
    }

    // Create an array of TodoItem structs
    TodoItem[] public todos;

    function createTodo(string memory _text) public {
        // There are multiple ways to initialize structs
        TodoItem memory item = TodoItem(_text, false);
        // Method 1 - Call it like a function
        todos.push(item);

        // Method 2 - Explicitly set its keys
        todos.push(TodoItem({text: _text, completed: false}));

        // Method 3 - Initialize an empty struct, then set individual properties
        TodoItem memory todo;
        todo.text = _text;
        todo.completed = false;
        todos.push(todo);
    }

    // Update a struct value
    function update(uint256 _index, string memory _text) public {
        todos[_index].text = _text;
    }

    // Update completed
    function toggleCompleted(uint256 _index) public {
        todos[_index].completed = !todos[_index].completed;
    }
}
