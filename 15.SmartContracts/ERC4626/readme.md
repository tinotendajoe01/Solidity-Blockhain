# ERC-4626: Overview and Enterprise Use Cases

ERC-4626 is a standard in the Ethereum blockchain network proposed to standardize tokenized vaults for yield-bearing tokens. This standard helps in exchange, liquidity, and flexibility among decentralized apps (dApps) and yield aggregators.

These vaults represent shares of a single underlying ERC-20 token. They are used widely in DeFi space by yield aggregators, lending markets, staking derivatives, and other dApps. However, challenges may arise when these vaults lack proper adaptability or standardization, leading to difficulties in conforming to industry standards like ERC-20 and confusing new developers. Thus, ERC-4626 comes into play, providing a standard API for tokenized yield-bearing vaults.

## Enterprise Use Cases

Here are a few ways ERC-4626 can be beneficial for enterprises:

1. **Standardization**: This standard simplifies the integration with vault smart contracts and yield-bearing tokens, thereby increasing smart contract development's time to market while decreasing potential risks.

2. **Composability**: ERC-4626 ensures composability between different protocol’s implementations of vault tokens, which could be important for enterprises aiming to launch new products integrated with different protocols’ tokens.

3. **Cross-Protocol Integrations**: By providing a uniform standard for projects to follow, ERC-4626 accelerates the process of cross-protocol integrations. A familiar and uniform standard also simplifies reasoning for developers, further reducing the likelihood of coding mistakes.

4. **Security**: By promoting uniform behavior and mutual understanding among dApps and yield aggregators, ERC-4626 offers added security layers against potential threats.

5. **Cost Reduction**: With ERC-4626, the need for auditors to assist with their adapters and interfaces is reduced, thereby cutting down costs.

## Example of an Enterprise Use Case: EnreachDAO

EnreachDAO is a prime example of an enterprise that adopted ERC-4626 with the launch of its Yaggr smart contract protocol. The company is now working on various real-world use cases that involve composing their products. ERC-4626, therefore, exposes EnreachDAO's products to a plethora of opportunities with other projects and users.

# ERC-4626 Complete Contract Implementation

```
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC4626 is IERC20 {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function pricePerShare() external view returns (uint256);
}

contract MyVault is IERC4626 {
    IERC20 public immutable token;

    constructor(IERC20 _token) {
        token = _token;
    }

    function totalSupply() external view override returns (uint256) {
        // Implement logic to calculate total supply
    }

    function balanceOf(address account) external view override returns (uint256) {
        // Implement logic to calculate balance of an account
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        // Implement logic to transfer tokens
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        // Implement logic to check the amount of tokens that an owner allowed to a spender
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        // Implement logic to set amount as the allowance of spender over the caller’s tokens
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        // Implement logic to move amount tokens from sender to recipient using allowance mechanism
    }

    function deposit(uint256 amount) external override {
        // Implement logic to deposit tokens into the vault
    }

    function withdraw(uint256 amount) external override {
        // Implement logic to withdraw tokens from the vault
    }

    function pricePerShare() external view override returns (uint256) {
        // Implement logic to calculate the price per share
    }
}

```

[SEE-DOC](https://docs.openzeppelin.com/contracts/4.x/erc4626)
