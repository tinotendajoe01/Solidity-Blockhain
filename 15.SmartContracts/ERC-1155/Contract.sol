// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { ERC1155Supply } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { PaymentSplitter } from "@openzeppelin/contracts/finance/PaymentSplitter.sol";

/// @title A store that uses ERC1155 tokens, with owner, pausable, supply tracking, and payment splitting functionality.
contract Web3Builders is
	ERC1155,
	Ownable,
	Pausable,
	ERC1155Supply,
	PaymentSplitter
{
	uint256 public publicPrice = 0.02 ether;
	uint256 public allowListPrice = 0.01 ether;
	uint256 public maxSupply = 20;
	uint public maxPerWallet = 3;

	bool public publicMintOpen = false;
	bool public allowListMintOpen = true;

	mapping(address => bool) allowList;
	mapping(address => uint256) purchasesPerWallet;

	/// @notice Creates a new store with the provided information.
	constructor(
		address[] memory _payees,
		uint256[] memory _shares
	)
		ERC1155("ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/")
		PaymentSplitter(_payees, _shares)
	{}

	/// @notice Changes the mint windows.
	function editMintWindows(
		bool _publicMintOpen,
		bool _allowListMintOpen
	) external onlyOwner {
		publicMintOpen = _publicMintOpen;
		allowListMintOpen = _allowListMintOpen;
	}

	/// @notice Adds specified addresses to the allow list.
	function setAllowList(address[] calldata addresses) external onlyOwner {
		for (uint256 i; i < addresses.length; ++i) {
			allowList[addresses[i]] = true;
		}
	}

	function setURI(string memory newuri) public onlyOwner {
		_setURI(newuri);
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	/// @notice Mint tokens for users that are in the allow list.
	function allowListMint(uint256 id, uint256 amount) public payable {
		require(allowListMintOpen, "Allow List mint is closed ");
		require(allowList[msg.sender], "You are not on the allowlist");
		require(msg.value == allowListPrice * amount);
		mint(id, amount);
	}

	/// @notice Mint tokens with public access.
	function publicMint(uint256 id, uint256 amount) public payable {
		require(publicMintOpen, "Public mint closed");
		require(
			id < 2,
			"Sorry looks like you are trying to mint the wrong NFT"
		);
		require(
			msg.value == publicPrice * amount,
			"WRONG! Not enough money sent"
		);
		mint(id, amount);
	}

	/// @notice Mint tokens to a specified wallet.
	function mint(uint256 id, uint256 amount) internal {
		require(
			purchasesPerWallet[msg.sender] + amount <= maxPerWallet,
			"Wallet limit reached"
		);
		require(
			id < 2,
			"Sorry looks like you are trying to mint the wrong NFT"
		);
		require(
			totalSupply(id) + amount <= maxSupply,
			"Sorry we have minted out!"
		);
		_mint(msg.sender, id, amount, "");
		purchasesPerWallet[msg.sender] += amount;
	}

	/// @notice Withdraws the balance to a specific address.
	function withdraw(address _addr) external onlyOwner {
		uint256 balance = address(this).balance; // get the balance of the smart contract
		payable(_addr).transfer(balance);
	}

	/// @notice Retrieves the URI of a specific token.
	function uri(
		uint256 _id
	) public view virtual override returns (string memory) {
		require(exists(_id), "URI: nonexistent token");

		return
			string(
				abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json")
			);
	}

	/// @notice Mints tokens in batch.
	function mintBatch(
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) public onlyOwner {
		_mintBatch(to, ids, amounts, data);
	}

	/// @notice Overrides the token transfer function to add additional checks and functionality.
	function _beforeTokenTransfer(
		address operator,
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) internal override(ERC1155, ERC1155Supply) whenNotPaused {
		super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
	}
}
