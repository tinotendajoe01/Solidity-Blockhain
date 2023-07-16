// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing required contracts and libraries
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/IERC721R.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A contract for Web3Builders NFTs
contract Web3Builders is ERC721A, Ownable {
	// Defining constants for Minting NFTs
	uint256 public constant mintPrice = 1 ether;
	uint256 public constant maxMintPerUser = 5;
	uint256 public constant maxMintSupply = 100;

	// Defining constants for Refund
	uint256 public constant refundPeriod = 3 minutes;
	uint256 public refundEndTimestamp;

	address public refundAddress;

	// Mappings for refund related data
	mapping(uint256 => uint256) public refundEndTimestamps;
	mapping(uint256 => bool) public hasRefunded;

	/// @notice Constructor function
	constructor() ERC721A("Web3Builders", "WE3") {
		refundAddress = address(this);
		refundEndTimestamp = block.timestamp + refundPeriod;
	}

	/// @notice Function to override base URI
	function _baseURI() internal pure override returns (string memory) {
		return "ipfs://QmbseRTJWSsLfhsiWwuB2R7EtN93TxfoaMz1S5FXtsFEUB/";
	}

	/// @notice Function for Safe Minting
	function safeMint(uint256 quantity) public payable {
		require(msg.value >= quantity * mintPrice, "Not enough funds");
		require(
			_numberMinted(msg.sender) + quantity <= maxMintPerUser,
			"Mint Limit"
		);
		require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");

		_safeMint(msg.sender, quantity);
		refundEndTimestamp = block.timestamp + refundPeriod;
		for (uint256 i = _currentIndex - quantity; i < _currentIndex; i++) {
			refundEndTimestamps[i] = refundEndTimestamp;
		}
	}

	/// @notice Function for Refunding
	function refund(uint256 tokenId) external {
		// you have to be the owner of the NFT
		require(
			block.timestamp < getRefundDeadline(tokenId),
			"Refund Period Expired"
		);
		require(msg.sender == ownerOf(tokenId), "Not your NFT");
		uint256 refundAmount = getRefundAmount(tokenId);

		// transfer ownership of NFT
		_transfer(msg.sender, refundAddress, tokenId);

		//mark refunded
		hasRefunded[tokenId] = true;
		// refund the Price
		Address.sendValue(payable(msg.sender), refundAmount);
	}

	/// @notice Function to get refund deadline
	function getRefundDeadline(uint256 tokenId) public view returns (uint256) {
		if (hasRefunded[tokenId]) {
			return 0;
		}
		return refundEndTimestamps[tokenId];
	}

	/// @notice Function to get refund amount
	function getRefundAmount(uint256 tokenId) public view returns (uint256) {
		if (hasRefunded[tokenId]) {
			return 0;
		}
		return mintPrice;
	}

	/// @notice Function to withdraw contract balance
	function withdraw() external onlyOwner {
		require(
			block.timestamp > refundEndTimestamp,
			"It's not past the refund period"
		);
		uint256 balance = address(this).balance;
		Address.sendValue(payable(msg.sender), balance);
	}
}
