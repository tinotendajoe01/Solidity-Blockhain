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
