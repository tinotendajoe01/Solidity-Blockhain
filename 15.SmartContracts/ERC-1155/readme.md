# ERC1155 Token Standard

ERC1155 is an innovative token standard on the Ethereum blockchain that is designed to be more adaptable, efficient, and powerful. The standard introduces a new type of token that encapsulates both fungible (ERC20) and non-fungible tokens (ERC721) in a single contract. ERC1155 tokens are defined by Enjin and were officially adopted as an Ethereum token standard in June 2019.

Compared to the previous standards, ERC1155 offers a more efficient pattern because it allows multiple tokens types to be minted or transferred using a single contract call, reducing the cost (gas fees) and complexity of operations.

## Key Features

### Batch Transfers

ERC1155 tokens can be sent in batches to one or more recipients. This includes tokens of different types. This significantly reduces transaction costs and improves operational efficiency when handling multiple tokens.

```
function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual;
```

### Fungibility Interchangeability

By encompassing the features of ERC20 (fungible) and ERC721 (non-fungible), ERC1155 can manage both fungible and non-fungible tokens. It offers flexibility for developers that's not possible with either ERC20 or ERC721 alone.

### Reduced Gas Fees

As a result of the batch operation functionality, ERC1155 significantly reduces gas fees for complex operations that involve multiple tokens. This makes it a very cost-effective solution for developers and users.

### Metadata Flexibility

ERC1155 introduces a metadata standard, which can be used to enrich tokens with additional information, such as name, description, or image. This standard supports both on-chain and off-chain metadata. Unlike ERC721, where metadata is mostly stored on-chain, increasing storage cost, ERC1155 permits the metadata to be hosted off-chain (for instance, on the IPFS), reducing costs.

```
function uri(uint256 id) public view virtual returns (string memory);
```

### Enhanced Access Control

ERC1155 contracts often feature access control mechanisms that provide certain levels of permission. For example, `Ownable` allows functions to be restricted to the contract owner only, and `Pausable` gives the owner the ability to pause the contract under specific circumstances, offering a higher level of security and control.

```
solidity function pause() public virtual onlyOwner; function unpause() public virtual onlyOwner;
```

## Conclusion

To sum up, ERC1155 provides a robust and flexible token standard that is optimized for the creation and management of both fungible and non-fungible tokens. Whether for gaming items, digital art, or any other digital assets, ERC1155 presents an efficient, secure, and cost-effective solution.
