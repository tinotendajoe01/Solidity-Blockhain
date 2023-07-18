# Simple Storage

## Table of Contents

- [Contracts](#Contracts)
  - [SimpleStorage](#SimpleStorage)
  - [StorageFactory](#StorageFactory)
  - [AddFiveStorage](#AddFiveStorage)
- [Usage](#Usage)
- [Author](#Author)
- [License](#License)

<br />

## Contracts

### `SimpleStorage`

This contract allows you to store an array of `Person` structures, each with a name and a favorite number. The contract includes basic CRUD functions for managing people in the array, as well as storing and retrieving a global number.

### StorageFactory

This contract is a Factory contract which deploys instances of the SimpleStorage contract. You can create multiple SimpleStorage contract instances, and store and retrieve an integer from each.

### `AddFiveStorage`

This contract is an extended version of SimpleStorage. It overrides the store function, adding 5 to the number before storing it.

<br />

## Usage

To use these contracts, you need to:

1. Compile the contracts with Solidity compiler (solc). If you're using a platform like Remix, this is done for you automatically.
2. Deploy the contracts using the Ethereum network of your choice. You can use a service like Metamask or Truffle for this.
3. Interact with the contracts using Web3 in a web browser or using Hardhat or Truffle scripts.

For more advanced usage, you'll typically want to integrate these contracts into a web interface using a library like Web3.js or Ethers.js.

## License

The contracts in this repository are licensed under the MIT license.

## Author

**Tinotenda Joe**

- [Profile](https://github.com/tinotendajoe01)
- [Email](mailto:tinotendajoe01@gmail.com)
- [Twitter](https://twitter.com/tinotendajoe01)

Please note that these contracts are for educational purposes and should not be used in production without further modifications. Always audit and test your contracts before using them in a live environment.

# NOTES

## Undestanding Solidity keywords

## VIRTUAL

In Solidity, the virtual keyword is used to mark a function as overridable in derived contracts. When a function is declared as virtual, it means that the function can be overridden by a function with the same name in a derived contract. The derived contract can provide its own implementation of the function, which will be used instead of the base implementation.

For example the store function is declared as virtual:

```
function store(uint256 _favoriteNumber) public virtual {
    myFavoriteNumber = _favoriteNumber;
}
```

This means that any derived contract can override this function and provide its own implementation. The virtual keyword allows for polymorphism in Solidity, where different derived contracts can have different behavior for the same function name.

For example, let's say we have a derived contract AdvancedStorage that extends SimpleStorage:

```
contract AdvancedStorage is SimpleStorage {
    // Override the store function
    function store(uint256 _favoriteNumber) public override {
        // Custom implementation
         myFavoriteNumber = _favoriteNumber + 1
    }
}
```

In this case, the store function in AdvancedStorage overrides the base implementation in SimpleStorage. When calling store on an instance of AdvancedStorage, the overridden function in AdvancedStorage will be executed instead of the base implementation in SimpleStorage.

The virtual keyword is important when designing contracts that allow for flexibility and customization in derived contracts. It enables the creation of contract hierarchies and the ability to override and extend functionality in a modular way developer.com.

## VIEW

In Solidity, the view keyword is used to indicate that a function does not modify the state of the contract. It is a function modifier that ensures that the function only reads data from the contract without making any changes to the contract's state variables.

```
// Function to retrieve the stored favorite number
function retrieve() public view returns (uint256) {
    return myFavoriteNumber;
}
```

By using the view keyword, this function promises not to modify the state of the contract. It simply returns the value of the myFavoriteNumber variable. This allows other contracts or external callers to read the value without incurring any `gas cost`.

The view keyword is particularly useful when you want to provide read-only access to certain data in your contract. It allows you to expose functionality that can be used to retrieve information from the contract without the need for a transaction.

For example, if you have a contract that stores some data and you want to provide a way for other contracts or users to retrieve that data without modifying it, you can declare a function as view. This ensures that the function can be called without incurring any gas cost and without modifying the contract's state.

```
function getData() public view returns (uint256) {
    return myData;
}
```

In this example, the getData function is declared as view because it only reads the value of myData and returns it. It does not modify any state variables in the contract.

Using the view keyword is a good practice when you have functions that are meant to retrieve data without changing anything in the contract. It provides clarity and helps users of your contract understand the intended behavior of the function.

## Memory

the memory keyword is used in the function parameter \_name to indicate that the string value passed to the function should be stored in memory.

```
// Function to add a person with their name and favorite number
function addPerson(string memory _name, uint256 _favoriteNumber) public {
    listofPeople.push(Person(_favoriteNumber, _name));
    nameToFavoriteNumber[_name] = _favoriteNumber;
}
```

In Solidity, there are three types of storage locations: `storage`, `memory`, and `calldata`.

storage refers to the contract's persistent storage, where state variables are stored.
memory is used for temporary storage during function execution and is cleared after the function ends.
calldata is a read-only space that contains the function arguments and external function call data.
In this case, the \_name parameter is declared as string memory, which means that the string value passed to the function will be stored in memory. This is appropriate because the function only needs to temporarily hold the name value to add it to the listofPeople array and update the nameToFavoriteNumber mapping.

Using memory for the \_name parameter helps optimize gas usage because it avoids unnecessary storage writes. Since the name does not need to be stored persistently in the contract, using memory is more efficient.

It's important to note that when working with memory, the data stored there is temporary and will be cleared once the function execution ends. Therefore, if you need to persistently store data, you should use storage instead.

Overall, using memory for the \_name parameter in the addPerson function ensures efficient and temporary storage of the name value during the function execution kristaps.me.

## Calldata

```
// Function to get a person's favorite number by their name
function getPersonFavoriteNumber(string calldata _name) public view returns (uint256) {
    return nameToFavoriteNumber[_name];
}
```

The calldata location is a special data location in Solidity that contains the function arguments. It is read-only and immutable, meaning that the data passed to the function cannot be modified.

In this case, the \_name parameter is declared as string calldata, which means that the string value passed to the function will be stored in the calldata location. This is appropriate for a view function like getPersonFavoriteNumber because it only needs to read the value of \_name to retrieve the corresponding favorite number from the nameToFavoriteNumber mapping.

Using calldata for the \_name parameter helps optimize gas usage because it avoids unnecessary memory copies and storage writes. Since the function is view and does not modify any state variables, using calldata is more efficient.

It's important to note that the calldata location is read-only, so any attempts to modify the value stored in calldata will result in a compilation error.

Overall, using calldata for the \_name parameter in the getPersonFavoriteNumber function ensures efficient and read-only access to the data passed to the function

### Storage

In Solidity, there are three main types of data storage: calldata, memory, and storage. Each of these types of storage has a different purpose and usage.

1. Calldata:
   Calldata is a special type of storage in Solidity that is used to hold function arguments and data passed into a function. It is read-only and cannot be modified by the function. Calldata is used when a function needs to access arguments or data passed into it, but does not need to modify them.

Example:

```
function doSomething(uint[] calldata nums) public {
    // Do something with the nums array
}
```

In this example, the `nums` array is passed into the `doSomething` function as calldata. The function can read the contents of the array, but it cannot modify it.

2. Memory:
   Memory is another type of storage in Solidity that is used to hold temporary data within a function. It is similar to calldata in that it is read-only, but unlike calldata, it can be modified by the function. Memory is used when a function needs to create or modify data that is not stored permanently on the blockchain.

Example:

```
function concatenateStrings(string memory str1, string memory str2) public pure returns (string memory) {
    bytes memory str1Bytes = bytes(str1);
    bytes memory str2Bytes = bytes(str2);
    bytes memory result = new bytes(str1Bytes.length + str2Bytes.length);

    uint i = 0;
    uint j = 0;

    for (i = 0; i < str1Bytes.length; i++) {
        result[j++] = str1Bytes[i];
    }

    for (i = 0; i < str2Bytes.length; i++) {
        result[j++] = str2Bytes[i];
    }

    return string(result);
}
```

In this example, the `concatenateStrings` function takes two string arguments and returns a concatenated string. The function creates a temporary `result` variable in memory to hold the concatenated string. The function modifies the contents of `result` by iterating over the bytes of the two input strings and copying them into `result`.

3. Storage:
   Storage is the most permanent type of storage in Solidity. It refers to the data that is stored on the blockchain and is persistent between function calls. Any data that needs to be stored permanently on the blockchain should be stored in storage. Storage is the most expensive type of storage in Solidity in terms of gas cost.

Example:

```
contract MyContract {
    uint private myNumber;

    function setNumber(uint _number) public {
        myNumber = _number;
    }

    function getNumber() public view returns (uint) {
        return myNumber;
    }
}
```

In this example, the `myNumber` variable is stored in storage. The `setNumber` function modifies the value of `myNumber`, which is then stored permanently on the blockchain. The `getNumber` function retrieves the value of `myNumber` from storage and returns it.
