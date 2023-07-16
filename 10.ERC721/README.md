# ERC and EIP

ERC stands for Ethereum Request for Comments. It is a type of standard that includes contract standards such as ERC-20 and ERC-721. ERCs are application-level standards for Ethereum and include contract standards such as the popular ERC-20 for fungible tokens and ERC-721 for non-fungible tokens. ERCs are part of the larger Ethereum Improvement Proposal (EIP) framework, but they are specifically for application-level standards and conventions, while other EIPs are for changes to the Ethereum protocol itself.

EIP, on the other hand, stands for Ethereum Improvement Proposal. An EIP is a design document providing information to the Ethereum community, or describing a new feature for Ethereum or its processes or environment. The EIP should provide a concise technical specification of the feature and a rationale for the feature.

## ERC-20

The ERC-20 is the standard API for tokens within smart contracts. This standard provides basic functionality to transfer tokens, as well as allow tokens to be approved so they can be spent by another on-chain third party.

The ERC-20 standard includes a set of functions that a token contract in Ethereum should implement. The functions are:

- `name()`: Returns the name of the token - e.g. "MyToken".
- `symbol()`: Returns the symbol of the token. E.g. "MT".
- `decimals()`: Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation.
- `totalSupply()`: Returns the total token supply.
- `balanceOf(address _owner)`: Returns the account balance of another account with address \_owner.
- `transfer(address _to, uint256 _value)`: Transfers \_value amount of tokens to address \_to, and should fire the Transfer event.
- `transferFrom(address _from, address _to, uint256 _value)`: Transfers \_value amount of tokens from address \_from to address \_to, and should fire the Transfer event.
- `approve(address _spender, uint256 _value)`: Allows \_spender to withdraw from your account, multiple times, up to the \_value amount.
- `allowance(address _owner, address _spender)`: Returns the amount which \_spender is still allowed to withdraw from \_owner.

## Implementation

There are already plenty of ERC20-compliant tokens deployed on the Ethereum network. Different implementations have been written by various teams that have different trade-offs: from gas saving to improved security.

...

# ERC-20 vs ERC-721

The primary difference between ERC-20 and ERC-721 lies in the concept of fungibility.

## Fungible Tokens (ERC-20)

Fungibility refers to items that are interchangeable with each other. ERC-20 tokens are fungible, meaning each token is identical to every other token; they are uniform and there is no difference between each token. This makes ERC-20 tokens useful for cryptocurrencies, as it allows any given ERC-20 token to be substituted with any other ERC-20 token.

Example: If you lend 1 Ether to a friend and they return 1 Ether to you a week later, it doesn't have to be the same Ether coin. Any Ether coin is equally valuable (ignoring minor price differences from one exchange to another).

## Non-Fungible Tokens (ERC-721)

Non-fungibility refers to items that are unique and not interchangeable. ERC-721 tokens are non-fungible, meaning each token has unique properties and they are not identical to each other. This makes ERC-721 tokens useful for representing ownership of unique items or assets, like a particular domain name or a specific piece of real estate.

Example: Imagine you borrowed a friend's car for the weekend. When you return it, you can't just give them any car in return. It has to be their car because every car is unique, with its own registration number, color, mileage, and condition. Similarly, each ERC-721 token is unique and can represent ownership over a specific, unique asset or item [wirexapp.com](https://www.makeuseof.com/difference-between-ethereum-erc-20-and-erc-721/), [](http://www.differencebetween.net/technology/difference-between-fungible-and-non-fungible-tokens/), [](https://ethereum.org/en/developers/docs/standards/tokens/erc-721/).

## Real-life Use Cases of ERC Tokens

### Tokenization of Real Estate Assets

Tokenization in real estate is the process of creating fractional ownership of an asset with the help of blockchain-based tokens, like ERC-20 or ERC-721 tokens. It helps in making the illiquid real estate assets, liquid. For instance, Elevated Returns, a New York-based asset management firm, completed its first tokenization real estate deal in 2018. The offering was made on St. Regis Resort in Aspen, Colorado, worth \$18 million on the Ethereum blockchain. The company decided to offer 18.9% ownership through the sale of tokens [hitechnectar.com](https://www.hitechnectar.com/blogs/use-cases-tokenization/).

### Cryptocurrencies and Financial Services

Many cryptocurrencies, especially those built on the ERC-20 standard, can be used for applications other than just paying for goods and services. They open up access to financial services for users around the world. Ethereum, for instance, was the catalyst for the growth of the crypto space into an industry through the ERC20 standard [bitpanda.com](https://www.bitpanda.com/academy/en/lessons/five-use-cases-of-cryptocurrencies/).

### Non-Fungible Tokens (NFTs)

Non-Fungible Tokens (NFTs), which are often built using the ERC-721 standard, have a wide range of use cases. They can represent ownership over digital or physical assets, and each token is unique, which means they cannot be replaced with something else. This uniqueness and the ability to prove ownership make NFTs ideal for tokenizing artworks, real estate, collectibles, and more [medium.com](https://medium.com/@blockdotco/the-ultimate-list-of-nft-non-fungible-tokens-real-use-cases-ab7ff93b0deb).

...
