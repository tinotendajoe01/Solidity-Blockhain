// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RaffleRewardNFT is ERC721 {
	uint256 private _tokenIdCounter;

	constructor() ERC721("RaffleRewardNFT", "RRNFT") {}

	function mint(address owner) public {
		_mint(owner, _tokenIdCounter);
		_tokenIdCounter++;
	}

	function tokenURI(
		uint256 tokenId
	) public view override returns (string memory) {
		return
			string(
				abi.encodePacked(
					"https://raffle-nft/",
					Strings.toString(tokenId)
				)
			);
	}
}
