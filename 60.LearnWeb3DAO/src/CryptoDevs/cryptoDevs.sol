// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Whitelist} from "./whitelist.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    error EXCEEDED_MAX_SUPPLY();
    error ALREADY_OWNED();
    error NOT_ENOUGH_ETHER();
    error FAILED_TO_SEND_ETHER();
    // Whitelist contract instance

    Whitelist public whitelist;
    //  _price is the price of one Crypto Dev NFT
    uint256 public constant _price = 0.01 ether;

    // Max number of CryptoDevs that can ever exist
    uint256 public constant maxTokenIds = 20;

    // Number of tokens reserved for whitelisted members
    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0;

    constructor(address whitelistContract) ERC721("Crypto Devs", "CD") {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.MAX_WHITE_LISTED_ADDRESSES();
    }

    function mint() public payable {
        // Make sure we always leave enough room for whitelist reservations
        if (totalSupply() + reservedTokens - reservedTokensClaimed > maxTokenIds) revert EXCEEDED_MAX_SUPPLY();
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
            if (balanceOf(msg.sender) != 0) revert ALREADY_OWNED();
            reservedTokens += 1;
        } else {
            if (msg.value < _price) revert NOT_ENOUGH_ETHER();
        }
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        payable(_owner).transfer(amount);
    }
}
