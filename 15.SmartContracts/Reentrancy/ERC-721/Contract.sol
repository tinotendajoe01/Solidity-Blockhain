// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WebIII is ERC721, ERC721Enumerable, Pausable, Ownable {
	using Counters for Counters.Counter;
	uint256 maxSupply = 1;
	bool public publicMintOpen = false;
	bool public allowListMintOpen = false;
	mapping(address => bool) public allowList;
	Counters.Counter private _tokenIdCounter;

	constructor() ERC721("Web3Builders", "WE3") {}

	function _baseURI() internal pure override returns (string memory) {
		return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	function editMintWindow(
		bool _publicMintOpen,
		bool _allowListMintOpen
	) external onlyOwner {
		publicMintOpen = _publicMintOpen;
		allowListMintOpen = _allowListMintOpen;
	}

	// add payment
	function publicMint() public payable {
		require(publicMintOpen, "Public mint closed");
		require(msg.value == 0.01 ether, "Not enough funds");
		internalMint();
	}

	function allowListMint() public payable {
		require(allowListMintOpen, "AllowList Mint Closed");
		require(allowList[msg.sender], "Not allowed");
		require(msg.value == 0.001 ether, "Not enough funds");
		internalMint();
	}

	function setAllowList(address[] calldata addresses) external onlyOwner {
		for (uint256 i; i < addresses.length; ++i) {
			allowList[addresses[i]] = true;
		}
	}

	function internalMint() internal {
		require(totalSupply() < maxSupply, "We sold out");
		uint256 tokenId = _tokenIdCounter.current();
		_tokenIdCounter.increment();
		_safeMint(msg.sender, tokenId);
	}

	function withdraw(address _addr) external onlyOwner {
		uint256 balance = address(this).balance;
		payable(_addr).transfer(balance);
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId,
		uint256 batchSize
	) internal override(ERC721, ERC721Enumerable) whenNotPaused {
		super._beforeTokenTransfer(from, to, tokenId, batchSize);
	}

	// The following functions are overrides required by Solidity.

	function supportsInterface(
		bytes4 interfaceId
	) public view override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
}
