// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
error ERC721Metadata__URI_QueryFor_NonExistentToken();
error MoodNft__CantFlipMoodIfNotOwner();

contract FundRaffleMoodNft is ERC721 {
	uint256 private s_tokenCounter;
	string private s_sadSvgUri;
	string private s_happySvgUri;
	enum NFTState {
		HAPPY,
		SAD
	}
	mapping(uint256 => NFTState) private s_tokenIdToState;
	event CreatedNFT(uint256 indexed tokenId);

	constructor(
		string memory sadSvgUri,
		string memory happySvgUri
	) ERC721("Mood NFT", "MN") {
		s_tokenCounter = 0;
		s_sadSvgUri = sadSvgUri;
		s_happySvgUri = happySvgUri;
	}

	function mintNft(address to) public {
		_safeMint(to, s_tokenCounter);
		s_tokenCounter = s_tokenCounter + 1;
		emit CreatedNFT(s_tokenCounter);
	}

	function _baseURI() internal pure override returns (string memory) {
		return "data:application/json;base64,";
	}

	function tokenURI(
		uint256 tokenId
	) public view virtual override returns (string memory) {
		if (!_exists(tokenId)) {
			revert ERC721Metadata__URI_QueryFor_NonExistentToken();
		}
		string memory imageURI = s_happySvgUri;
		if (s_tokenIdToState[tokenId] == NFTState.SAD) {
			imageURI = s_sadSvgUri;
		}
		return
			string(
				abi.encodePacked(
					_baseURI(),
					Base64.encode(
						bytes(
							abi.encodePacked(
								'{"name":"',
								name(), // You can add whatever name here
								'", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
								'"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
								imageURI,
								'"}'
							)
						)
					)
				)
			);
	}

	function getHappySVG() public view returns (string memory) {
		return s_happySvgUri;
	}

	function getSadSVG() public view returns (string memory) {
		return s_sadSvgUri;
	}

	function getTokenCounter() public view returns (uint256) {
		return s_tokenCounter;
	}
}
