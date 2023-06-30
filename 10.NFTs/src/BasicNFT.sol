// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Importing the ERC721 contract from the OpenZeppelin library
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Define a new contract named BasicNft that inherits from the ERC721 contract
contract BasicNft is ERC721 {
	// Define an error that is thrown when a token URI is not found
	error BasicNft__TokenUriNotFound();

	// Define a private mapping to link each token ID to its URI
	mapping(uint256 => string) private s_tokenIdToUri;

	// Define a private counter to keep track of the total number of minted tokens
	uint256 private s_tokenCounter;

	// Define the constructor that initializes the ERC721 contract with a name and symbol and sets the token counter to zero
	constructor() ERC721("Dogie", "DOG") {
		s_tokenCounter = 0;
	}

	// Define a public function that allows a user to mint a new token with a specific URI
	function mintNft(string memory tokenUri) public {
		// Store the URI in the mapping using the current token counter as the key
		s_tokenIdToUri[s_tokenCounter] = tokenUri;

		// Call the _safeMint function inherited from the ERC721 contract to mint the token
		_safeMint(msg.sender, s_tokenCounter);

		// Increment the token counter
		s_tokenCounter = s_tokenCounter + 1;
	}

	// Override the tokenURI function from the ERC721 contract to return the URI of a specific token
	function tokenURI(
		uint256 tokenId
	) public view override returns (string memory) {
		// If the token does not exist, revert the transaction with a BasicNft__TokenUriNotFound error
		if (!_exists(tokenId)) {
			revert BasicNft__TokenUriNotFound();
		}

		// Return the URI stored in the local s_tokenIdToUri mapping
		return s_tokenIdToUri[tokenId];
	}

	// Define a public view function that returns the current value of the token counter
	function getTokenCounter() public view returns (uint256) {
		return s_tokenCounter;
	}
}
