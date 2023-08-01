# IOracle
[Git Source](https://github.com/tinotendajoe01/Solidity-Blochain/blob/cf463adb86eb681dea89cb8178867ce0ef041f33/src/interfaces/IOracle.sol)


## Functions
### getTokenValueOfEth

return amount of tokens that are required to receive that much eth.


```solidity
function getTokenValueOfEth(uint256 ethOutput) external view returns (uint256 tokenInput);
```

