// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

// Importing the ERC20 standard from the OpenZeppelin contracts library.
// OpenZeppelin contracts are a library for secure smart contract development.
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// OurToken is a new contract that extends the ERC20 contract from OpenZeppelin.
// ERC20 is a standard interface for fungible tokens.
// Inheriting from this contract means that OurToken will behave just like any other ERC20 token.
contract OurToken is ERC20 {
	// The constructor function is called once when the contract is deployed.
	// It sets the name and symbol of the token and mints the initial supply of the token to the address that deploys the contract.
	constructor(uint256 initailSupply) ERC20("Our Token", "OT") {
		// `_mint` is a function from the ERC20 contract that creates `initailSupply` amount of tokens
		// and assigns it to `msg.sender` (the account that called this contract, i.e., the account that deploys the contract).
		_mint(msg.sender, initailSupply);
	}
}
