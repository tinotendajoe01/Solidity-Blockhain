# BasicNft.sol

The BasicNft smart contract is an implementation of a basic Non-Fungible Token (NFT) contract using the ERC721 standard from OpenZeppelin. The contract allows for the minting of new tokens, each with a unique URI that links to its metadata.

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
	error BasicNft__TokenUriNotFound();
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
revert BasicNft**TokenUriNotFound();
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
