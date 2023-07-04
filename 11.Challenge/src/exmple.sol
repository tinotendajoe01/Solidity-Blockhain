// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract Name {
	function generateRandomMetadata() internal view returns (string memory) {
		// Generate a random identifier using the block timestamp and the current block number
		bytes32 randomHash = keccak256(
			abi.encodePacked(block.timestamp, block.number)
		);

		// Convert the random hash to a string
		string memory randomString = bytes32ToString(randomHash);

		// Concatenate the random string with a prefix to create the final metadata
		string memory metadata = string(
			abi.encodePacked("Random NFT Metadata: ", randomString)
		);

		return metadata;
	}

	function bytes32ToString(
		bytes32 _bytes32
	) internal pure returns (string memory) {
		bytes memory bytesArray = new bytes(64);
		for (uint256 i; i < 32; i++) {
			uint256 value = uint256(uint8(_bytes32[i]));
			bytes1 char = bytes1((value & 0xff));
			bytesArray[i * 2] = char;
			bytesArray[i * 2 + 1] = char;
		}
		return string(bytesArray);
	}
}