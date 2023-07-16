# ERC721A

The ERC721A is a custom implementation of the standard ERC721 interface that is designed to make the process of minting NFTs (Non-Fungible Tokens) more efficient on EVM-compatible blockchains. Its creation was spearheaded by Azuki, a digital art initiative.

The standard ERC721 provides an interface for dealing with NFTs which includes a set of rules to ease interactions with them. However, a limitation of the standard ERC721 is that it doesn't naturally support the minting of multiple NFTs in a single transaction.

The ERC721A implementation seeks to address this limitation by offering an optimal version that allows for significant gas savings when minting multiple NFTs simultaneously. Essentially, with ERC721A, you can mint multiple NFTs for approximately the same cost of minting just one token using the standard ERC721. Given the recent high Ethereum gas prices, the ERC721A provides a significant economic advantage to NFT collectors.

A typical ERC721 tracks several elements such as Owners, Balances, and various Approvals. However, without additional storage, base ERC721 cannot use important functions such as totalSupply(), tokenOfOwnerByIndex, and tokenByIndex. However, when using ERC721 Enumerable, every mint action necessitates an update to the state, reflecting new data added to their storage. Azuki simplified this process by noting that most NFT collections do not use or require these extra variables.

In the ERC721A contract, the \_safeMint implementation means owner balances are only updated once, regardless of the number of tokens minted. This reduced number of updates again saves on gas costs.

Here is a truncated example of how to create and deploy an ERC721A contract using solidity:

```
// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
pragma solidity ^0.8.0;
import "./utils/Context.sol";

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

```

# Contract.sol Web3builders

The given contract `Web3Builders` is a custom implementation of the ERC721A standard. Here's a detailed breakdown of the contract:

- **Import Statements**: These are used to include other smart contracts or libraries your contract is using. In this case, `ERC721A`, `IERC721R`, and `Ownable` are being used.

- **Inheritance**: The contract is inheriting from `ERC721A` and `Ownable`. `ERC721A` is the token standard and `Ownable` is a contract module which provides basic authorization control functions, simplifies the implementation of "user permissions".

- **Constants**: It has several defined constants like the `mintPrice`, `maxMintPerUser`, `maxMintSupply`, and `refundPeriod`.

- **Refund End Timestamp**: `refundEndTimestamp` is used to calculate the time when the refund period ends.

- **Refund Address**: `refundAddress` designates where the refunded amount should be sent to, in this case, it points to the contract address itself.

- **Mappings**: Two mappings `refundEndTimestamps`, and `hasRefunded` are used where the data type of the key is uint256 and the value is uint256 and bool respectively. Mappings can be seen as hash tables which are virtually initialized such that every possible key exists and is mapped to a value.
