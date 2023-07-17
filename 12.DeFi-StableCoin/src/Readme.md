# Understanding the contracts

## DecentralizedStableCoin

### Import Statements

```
import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

```

Here, the contract imports the ERC20Burnable token standard and the Ownable contract from the OpenZeppelin smart contracts library.

- ERC20 is a standard interface for fungible tokens, which means the tokens are interchangeable with each other.
- ERC20Burnable provides a `burn` function to destroy token and reduce its total supply.
- `Ownable` is a contract that has an owner address and provides basic authorization control functions.

### Contract Declaration

```
contract DecentralizedStableCoin is ERC20Burnable, Ownable {... }

```

The main contract ` DecentralizedStableCoin`` is declared here. It inherits from both  `ERC20Burnable`and`Ownable`. This means that it has all the properties and methods in these contracts.

### Constructor

```
constructor() ERC20("DecentralizedStableCoin", "DSC") {...}

```

The constructor is called once when the contract is deployed. This contract calls the ERC20 constructor with the name and symbol of the new token.

### Burn Function

```
function burn(uint256 _amount) public override onlyOwner {...}

```

The `burn` function is overridden here to provide custom functionality. This function is marked with onlyOwner, which means that only the owner of the contract can execute this function.

This function checks that the amount to be burnt is greater than 0 and less than or equal to the user's balance, and then executes the burn operation by calling the `_burn` function of the `ERC20Burnable` contract.

### Mint Function

```
function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {...}

```

The`mint` function creates new tokens. It requires the recipient's address and the amount to mint. The function can only be called by the owner of the contract (as indicated by `onlyOwner`).

This function checks that the recipient's address is not 0 and that the amount to mint is greater than 0, then mints the tokens by calling the `_mint` function of the `ERC20` contract. The function returns `true` upon successful minting operation.

## library OracleLib

The OracleLib library imports the AggregatorV3Interface from the Chainlink contracts, which exposes function calls to interact with Chainlink oracle price feeds.

### Constant Declaration

```
uint256 private constant TIMEOUT = 3 hours;
```

This line declares a TIMEOUT constant and sets it to 3 hours. This constant will be used to define the condition for data to be considered "stale".

### Stale Check Function

```
function staleCheckLatestRoundData(
  AggregatorV3Interface chainlinkFeed
) public view returns (uint80, int256, uint256, uint256, uint80) {
  (
    uint80 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint80 answeredInRound
  ) = chainlinkFeed.latestRoundData();

  if (updatedAt == 0 || answeredInRound < roundId) {
    revert OracleLib__StalePrice();
  }
  uint256 secondsSince = block.timestamp - updatedAt;
  if (secondsSince > TIMEOUT) revert OracleLib__StalePrice();

  return (roundId, answer, startedAt, updatedAt, answeredInRound);
}

```

The function `staleCheckLatestRoundData` is used to check if the data from a Chainlink oracle feed is stale. This function accepts `chainlinkFeed` as an input.

This function calls the `latestRoundData` method of the passed feed and de-structures its returned data into `roundId`, `answer`, `startedAt`,` updatedAt`, and` answeredInRound`.

Then, it checks if 'updatedAt' is zero, or if 'answeredInRound' is less than 'roundId'. If any of these conditions are met, the function reverts and produces a `OracleLib__StalePrice error`.

After establishing these initial checks, the function calculates how much time has passed since the data was updated by subtracting 'updatedAt' from the current block timestamp (`block.timestamp`).

If the time difference is greater than` TIMEOUT`, the function reverts and produces a `OracleLib__StalePrice` error, marking the data as stale.

Finally, if none of the checks cause a revert, the function returns the round data, indicating that the data from the oracle is fresh.

### Get Timeout Function

```
function getTimeout(
  AggregatorV3Interface /* chainlinkFeed */
) public pure returns (uint256) {
  return TIMEOUT;
}
```

This function, `getTimeout`, returns the `TIMEOUT` value when called. Note that it declares an unused variable `chainlinkFeed` - presumably this function could be modified in the future to return different timeouts for different feeds.

In summary, the purpose of this library is to create reusable code to interact with a Chainlink price feed, specifically checking whether the latest data is stale based on some predefined conditions.

# DCSEngine.sol

## Deposit Collateral fx

### 1. Increment Collateral Balance

```
s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;


```

This line increments the amount of collateral deposited by the `msg.sender` for the specified `tokenCollateralAddress`. It adds the `amountCollateral` to the existing collateral balance.

### 2. Emit Collateral Deposited Event

`emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);`

This line emits an event called `CollateralDeposited` to notify the system that collateral has been deposited. It includes the `msg.sender` (the address of the caller), `tokenCollateralAddress` (the address of the collateral token), and `amountCollateral` (the amount of collateral deposited) as parameters.

### 3. Transfer Collateral

```
bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);

```

This line transfers the `amountCollateral` of the specified `tokenCollateralAddress` from the `msg.sender` to the contract (`address(this)`). It uses the `transferFrom` function of the ERC20 token contract to perform the transfer. The function returns a boolean value (`success`) indicating whether the transfer was successful or not.

## MintDSC

### Health factor

```
/**
 * @title HealthFactorCalculator
 * @dev A contract that calculates the health factor of a user based on their totalDscMinted and collateralValueInUsd.
 */
contract HealthFactorCalculator {
    /**
     * @notice Calculates the health factor of a user based on their totalDscMinted and collateralValueInUsd.
     * @param user The address of the user for whom to calculate the health factor.
     * @return The health factor value.
     */
    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
        return _calculateHealthFactor(totalDscMinted, collateralValueInUsd);
    }

    /**
     * @notice Calculates the health factor based on the totalDscMinted and collateralValueInUsd.
     * @param totalDscMinted The total amount of DSC minted.
     * @param collateralValueInUsd The collateral value in USD.
     * @return The calculated health factor value.
     */
    function _calculateHealthFactor(uint256 totalDscMinted, uint256 collateralValueInUsd)
        internal
        pure
        returns (uint256)
    {
        if (totalDscMinted == 0) return type(uint256).max;
        uint256 collateralAdjustedForThreshold = (collateralValueInUsd * LIQUIDATION_THRESHOLD) / 100;
        return (collateralAdjustedForThreshold * 1e18) / totalDscMinted;
    }

    /**
     * @notice Reverts if the user's health factor is below the minimum health factor.
     * @param user The address of the user to check.
     */
    function revertIfHealthFactorIsBroken(address user) internal view {
        uint256 userHealthFactor = _healthFactor(user);
        if (userHealthFactor < MIN_HEALTH_FACTOR) {
            revert DSCEngine__BreaksHealthFactor(userHealthFactor);
        }
    }
}

```
