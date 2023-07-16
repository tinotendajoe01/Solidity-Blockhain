// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing required OpenZeppelin contracts
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";

/// @title WebIII ERC721 Contract
/// @dev This contract extends ERC721, ERC721Enumerable, Pausable, and Ownable contracts from OpenZeppelin.
contract WebIII is ERC721, ERC721Enumerable, Pausable, Ownable {
	// Using Counters library for managing token IDs
	using Counters for Counters.Counter;

	// Maximum supply of tokens
	uint256 maxSupply = 1;

	// Boolean variables to control public and allowList minting
	bool public publicMintOpen = false;
	bool public allowListMintOpen = false;

	// Mapping to keep track of addresses in the allowList
	mapping(address => bool) public allowList;

	// Counter for token IDs
	Counters.Counter private _tokenIdCounter;

	/// @dev Contract constructor that sets the name and symbol of the token.
	constructor() ERC721("Web3Builders", "WE3") {}

	/// @dev Function to set the base URI for the token metadata.
	function _baseURI() internal pure override returns (string memory) {
		return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
	}

	/// @dev Function to pause the contract. Can only be called by the owner.
	function pause() public onlyOwner {
		_pause();
	}

	/// @dev Function to unpause the contract. Can only be called by the owner.
	function unpause() public onlyOwner {
		_unpause();
	}

	/// @dev Function to edit the minting window. Can only be called by the owner.
	function editMintWindow(
		bool _publicMintOpen,
		bool _allowListMintOpen
	) external onlyOwner {
		publicMintOpen = _publicMintOpen;
		allowListMintOpen = _allowListMintOpen;
	}

	/// @dev Function for public minting of tokens.
	function publicMint() public payable {
		require(publicMintOpen, "Public mint closed");
		require(msg.value == 0.01 ether, "Not enough funds");
		internalMint();
	}

	/// @dev Function for allowList minting of tokens.
	function allowListMint() public payable {
		require(allowListMintOpen, "AllowList Mint Closed");
		require(allowList[msg.sender], "Not allowed");
		require(msg.value == 0.001 ether, "Not enough funds");
		internalMint();
	}

	/// @dev Function to set the allowList. Can only be called by the owner.
	function setAllowList(address[] calldata addresses) external onlyOwner {
		for (uint256 i; i < addresses.length; ++i) {
			allowList[addresses[i]] = true;
		}
	}

	// 	function setAllowList2(address[] calldata addresses) external onlyOwner {
	// 	for (uint256 i=0; i < addresses.length; i++) {
	// 		allowList[addresses[i]] = true;
	// 	}
	// }

	/// @dev Internal function to mint tokens.
	function internalMint() internal {
		require(totalSupply() < maxSupply, "We sold out");
		uint256 tokenId = _tokenIdCounter.current();
		_tokenIdCounter.increment();
		_safeMint(msg.sender, tokenId);
	}

	/// @dev Function to withdraw the balance of the contract. Can only be called by the owner.
	function withdraw(address _addr) external onlyOwner {
		uint256 balance = address(this).balance;
		payable(_addr).transfer(balance);
	}

	/// @dev Function to handle token transfers.
	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId,
		uint256 batchSize
	) internal override(ERC721, ERC721Enumerable) whenNotPaused {
		super._beforeTokenTransfer(from, to, tokenId, batchSize);
	}

	/// @dev Function to check if the contract supports a specific interface.
	function supportsInterface(
		bytes4 interfaceId
	) public view override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
}
