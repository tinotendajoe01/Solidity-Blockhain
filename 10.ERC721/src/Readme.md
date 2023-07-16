```markdown
# BasicNft Smart Contract

The `BasicNft` smart contract is an implementation of a basic Non-Fungible Token (NFT) contract using the `ERC721` standard from `OpenZeppelin`. The contract allows for the minting of new tokens, each with a unique URI that links to its metadata.

Breaking down this contract:

The contract starts with specifying the Solidity version and importing the ERC721 contract from OpenZeppelin. OpenZeppelin is a library for secure smart contract development.
```

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

```

The contract BasicNft is defined, which inherits from the ERC721 contract. The contract has a mapping `s_tokenIdToUri` to store the URI for each token ID, and a counter `s_tokenCounter` to keep track of the total number of minted tokens.

```

contract BasicNft is ERC721 {
error BasicNft\_\_TokenUriNotFound();
mapping(uint256 => string) private s_tokenIdToUri;
uint256 private s_tokenCounter;

```

The constructor initializes the ERC721 contract with a name and symbol, and sets the token counter to zero.
constructor() ERC721("Dogie", "DOG") {
s_tokenCounter = 0;
}
The mintNft function allows a user to mint a new token with a specific URI. The function updates the `s_tokenIdToUri` mapping and increments the token counter.

```

function mintNft(string memory tokenUri) public {
s_tokenIdToUri[s_tokenCounter] = tokenUri;
\_safeMint(msg.sender, s_tokenCounter);
s_tokenCounter = s_tokenCounter + 1;
}

```

The tokenURI function is an override of the tokenURI function in the ERC721 contract. It returns the URI of a specific token. If the token does not exist, it reverts the transaction with a BasicNft\*\*TokenUriNotFound error.

```

function tokenURI(
uint256 tokenId
) public view override returns (string memory) {
if (!\_exists(tokenId)) {
revert BasicNft\*\*TokenUriNotFound();
}
return s_tokenIdToUri[tokenId];
}

```

The getTokenCounter function returns the current value of the token counter.

```

function getTokenCounter() public view returns (uint256) {
return s_tokenCounter;
}
}

```

```

```markdown
# MoodNft Smart Contract

The `MoodNft` smart contract is an ERC721 token contract that represents mood-based non-fungible tokens (NFTs). Each NFT in this contract has a mood state, either "HAPPY" or "SAD", which can be flipped by the owner of the token.

## Contract Layout

The contract follows a specific layout to organize its different components:

- Version: Indicates the version of the Solidity compiler and the license of the contract.
- Imports: The contract imports necessary external contracts such as ERC721 from OpenZeppelin and Ownable for access control.
- Errors: Custom error messages used in the contract.
- Interfaces, Libraries, Contracts: Any interfaces, libraries, or other contracts used by the contract.
- Type Declarations: Enumerations and other type declarations used in the contract.
- State Variables: The contract's state variables, including the token counter and the URIs for the SVG images representing the happy and sad moods.
- Events: The events emitted by the contract, including the event for when an NFT is created.
- Modifiers: Any custom modifiers used in the contract.
- Functions: The contract's functions, including the constructor and other utility functions.

## Contract Functions

The `MoodNft` contract contains the following functions:

- `constructor(string memory sadSvgUri, string memory happySvgUri)`: The constructor function that initializes the contract. It takes two parameters, the URIs for the SVG images representing the sad and happy moods.
- `mintNft()`: A public function that allows users to mint a new NFT. It mints a new token and assigns it to the caller of the function.
- `flipMood(uint256 tokenId)`: A public function that allows the owner of an NFT to flip its mood state between "HAPPY" and "SAD". It checks if the caller is the owner of the token before allowing the mood flip.
- `_baseURI()`: An internal function that returns the base URI for the token metadata.
- `tokenURI(uint256 tokenId)`: A public view function that returns the metadata URI for a given token. It includes the name, description, moodiness attribute, and image URI based on the token's mood state.
- `getHappySVG()`: A public view function that returns the URI for the SVG image representing the happy mood.
- `getSadSVG()`: A public view function that returns the URI for the SVG image representing the sad mood.
- `getTokenCounter()`: A public view function that returns the current token counter.

## Additional Explanation

- The contract inherits from the `ERC721` contract provided by OpenZeppelin, which implements the ERC721 standard for non-fungible tokens.
- The contract also inherits from the `Ownable` contract provided by OpenZeppelin, which provides basic access control functionalities.
- The contract uses an enumeration `NFTState` to represent the two mood states: "HAPPY" and "SAD".
- The contract uses a private mapping `s_tokenIdToState` to keep track of the mood state for each token.
- The `CreatedNFT` event is emitted whenever a new NFT is minted.
- The `tokenURI` function generates a JSON metadata string that includes the name, description, moodiness attribute, and image URI for a given token. It uses the `Base64` library from OpenZeppelin to encode the JSON string.
- The contract provides getter functions for the happy and sad SVG URIs, as well as the current token counter.

Please note that this is a high-level explanation of the `MoodNft` smart contract and its fundamental components. For a more detailed understanding, it is recommended to review each function and its implementation in the contract code.
```

### Constructor

The `constructor` function initializes the contract by setting the initial values for the sad and happy SVG URIs. It takes two parameters, `sadSvgUri` and `happySvgUri`, which are the URIs for the SVG images representing the sad and happy moods respectively. These URIs are stored in the contract's state variables `s_sadSvgUri` and `s_happySvgUri`. Here's the code snippet:

```
	constructor(
		string memory sadSvgUri,
		string memory happySvgUri
	) ERC721("Mood NFT", "MN") {
		s_tokenCounter = 0;
		s_sadSvgUri = sadSvgUri;
		s_happySvgUri = happySvgUri;
	}
```

### `_baseURI` Function

The `_baseURI` function is an internal function that is used to return the base URI for the token metadata. In this contract, the base URI is set to `"data:application/json;base64,"`, which indicates that the metadata is encoded in base64 format. Here's the code snippet:

```
	function _baseURI() internal pure override returns (string memory) {
		return "data:application/json;base64,";
	}

```

### `tokenURI` Function

The `tokenURI` function is a public view function that returns the metadata URI for a given token. It generates a JSON metadata string that includes the name, description, moodiness attribute, and image URI based on the token's mood state. The JSON string is then encoded in base64 format using the `Base64.encode` function from the OpenZeppelin library. Here's the code snippet:

```

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

```

The `abi.encodePacked` function is used to concatenate multiple strings and variables into a single byte array. In the `tokenURI` function, it is used to concatenate the different components of the JSON metadata string.

The `Base64.encode` function from the OpenZeppelin library is used to encode the JSON string in base64 format. It takes a byte array as input and returns the base64 encoded string.

...
