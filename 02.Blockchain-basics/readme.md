# Blockchain and the Evolution of the Web - A Primer

This section serves as a high-level guide to some key concepts in the blockchain space and the evolution of the internet.

## Blockchain Overview

Blockchain works by packaging data into blocks, and chaining them together in a fixed sequence. It uses cryptographic techniques for secure functionalities:

SHA256: A cryptographic hash function, playing a crucial role in block creation. It generates an almost-unique fixed-size output for each unique input.

Blocks: These are like pages of a ledger that are linked together forming a chain of blocks.

Mining: The process that adds transaction records to Bitcoin's public ledger. It involves compiling recent transactions and trying to guess a complex function.

Distributed Systems: Blockchains are decentralized. They use various machines and servers around the world for data storage and verification, hence there is no single authority.

## Content

1. [Bitcoin](#bitcoin)
2. [Ethereum](#ethereum)
3. [Smart Contracts](#smart-contracts)
4. [Oracles](#oracles)
5. [On-chain and Off-chain Links](#on-chain-and-off-chain-links)
6. [Chainlink](#chainlink)
7. [Hybrid Smart Contracts](#hybrid-smart-contracts)
8. [Smart Contract Platforms](#smart-contract-platforms)
9. [DApp](#dapp)
10. [Web1.0](#web10)
11. [Web2.0](#web20)
12. [Web3.0](#web30)

## Bitcoin

Bitcoin is a decentralized digital currency introduced in 2009 by a pseudonymous creator or creators known as Satoshi Nakamoto. Utilizing a peer-to-peer network, Bitcoin operates on the proof-of-work consensus mechanism where transactions are recorded on a blockchain in a secure and transparent manner.

## Ethereum

Ethereum is a decentralized, open-source blockchain network that enables the creation of smart contracts and decentralized applications (dApps), developed by Vitalik Buterin. Although started with a proof-of-work consensus mechanism like Bitcoin, Ethereum is transitioning to a proof-of-stake mechanism known as Ethereum 2.0.

## Private and Public Keys and Digital Signatures in Blockchain

One fundamental aspect of Blockchain technology is the use of private and public keys. In the traditional sense, a "key" is a unique identifier that helps gain access to something valuable. In blockchain:

- Public key: This is derived from the private key and linked to a specific user. It's out in the open and can be shared with everyone; yet, it gives away no information about the private key which can be detrimental if known by wrong parties.
- Private key: This is a sophisticated form of cryptography that allows a user to access his or her cryptocurrency. It’s like a password but much more secure, non-transferable, and provides non-repudiable identification of the party.

Digital Signature: It is a mathematical technique used to validate the authenticity and integrity of a message, software, or digital document. It's the digital equivalent of a handwritten signature or stamped seal, but it offers far more inherent security. Public and private keys are an essential aspect of digital signatures.

## Blockchain Transactions, Addresses, and Fees

In blockchain technology, a transaction denotes the transfer of cryptocurrency from one address to another. Each transaction gets recorded on the blockchain network, and cryptographic algorithms, like SHA256, secure it.

**Addresses:**
Each address is a distinct identifier connected to a user's public key, and it facilitates the sending and receiving of cryptocurrency transactions on the blockchain network. Each address can hold a balance of cryptocurrency, which can be used for transactions with other addresses.

**Transaction Fees:**
Every transaction must include a fee. This transaction fee is paid to miners, who then validate and add the transaction to the blockchain. Typically, the size of the transaction and the current demand for block space on the network dictate the transaction fee.

**Gas Fees:**
Gas is the computational effort it takes to execute a transaction, measured in gwei units (a subunit of the cryptocurrency on the network). Each block on the network has a gas limit—the maximum amount of gas that can be used to execute the block's transactions. Users determine the gas price based on what they're willing to pay, and it is typically denominated in gwei. The complete gas fee is calculated as the gas price multiplied by the gas used.

On the Ethereum network, one gwei equals one billionth of an ETH (Ether). The gas fee compensates for the computational cost of executing the transaction.

So, both transaction and gas fees are mandatory for every blockchain transaction. While the transaction fee is paid to miners to validate and add the transaction to the blockchain, the gas fee compensates for the computational efforts of executing the transaction.

## Smart Contracts

Smart contracts are programmable contracts that self-execute once predefined conditions are met. Stored on the blockchain, smart contracts encode business rules in a programmable language and offer a secure, transparent, and tamper-resistant method to execute and record transactions.

Smart contracts have several values, including automation, transparency, security, and efficiency:

1. Automation: Smart contracts can automate complex transactions by removing the need for intermediaries and reducing the time and cost associated with traditional contract execution.
2. Transparency: Smart contracts operate on a decentralized blockchain network, providing high-level transparency and accountability. Each party has equal access to the contract terms, and all contract actions are recorded on the blockchain, making it easy to trace the contract's history.

3. Security: Smart contracts are designed to be secure and tamper-proof. The terms of the contract can't be altered once it's deployed on the blockchain, ensuring that the terms of the contract are enforced as intended.

4. Efficiency: By eliminating the need for intermediaries, reducing transaction costs, and speeding up contract execution, smart contracts can improve transaction efficiency in various industries.

Some of the problems smart contracts solve include:

1. Lack of trust: Traditional contracts often require intermediaries like lawyers or banks to validate and enforce contracts' terms. Smart contracts eliminate the need for intermediaries and use decentralized blockchain technology to enforce the contract's conditions, fostering trust between parties.
2. Time-consuming and costly processes: Execution of traditional contracts can be time-consuming and expensive as they require multiple parties to review, negotiate, and sign the contract. Contrarily, smart contracts self-execute, reducing the time and cost of execution.
3. Lack of Transparency: Traditional contracts can lack transparency since their terms may be unclear or difficult to understand for all parties. On the other hand, smart contracts are transparent and accessible to all parties involved with the terms of the contract recorded on the blockchain network.

4. Risk of fraud: Traditional contracts can be prone to fraud as one party can alter contract terms without the other party's knowledge. In contrast, smart contracts are tamper-proof and secure, with non-alterable terms once deployed on the blockchain.

Overall, smart contracts streamline several transaction aspects, offering automation, increased transparency and accountability, enhanced security, and reduced costs. Therefore, smart contracts are considered revolutionary for many industries.

## Oracles

Oracles are trusted data feeds that send information into the smart contracts, bridging the gap between blockchain and the outside world. As blockchains cannot access off-chain data, oracles provide a way to bring this external data onto the blockchain.

## On-chain and Off-chain Links

On-chain and off-chain links refer to interactions that occur on the blockchain network (on-chain) and outside of it (off-chain). On-chain interactions are transactions that occur on the blockchain and are validated by network participants, while off-chain interactions take place outside the network and do not involve the blockchain directly.

## Chainlink

Chainlink is a decentralized oracle network that provides real-world data to smart contracts on the blockchain. It is a bridge between the on-chain and off-chain worlds and enhances the functionality of smart contracts by enabling them to interact with resources outside the blockchain network.

## Hybrid Smart Contracts

Hybrid smart contracts use a combination of on-chain and off-chain data and logic to perform complex computations and transactions. They utilize oracles to access off-chain data and execute smart contract logic on the blockchain, resulting in a hybrid model that combines the advantages of both on-chain and off-chain approaches.

## Smart Contract Platforms

Smart Contract Platforms like Ethereum, Cardano, and others provide a decentralised platform for creating, deploying, and executing smart contracts. They offer features like smart contract templates, developer tools, and decentralized governance mechanisms.

## DApp

Decentralized Applications (DApps) are digital applications or programs that operate on a blockchain or peer-to-peer network of computers instead of a single computer, and are outside the purview and control of a single authority.

## Web1.0

Also known as the 'read-only' web, Web 1.0 was the first generation of the World Wide Web. It was characterized by static, read-only web pages that were created in HTML and were for purely informational purposes.

## Web2.0

Web 2.0, also known as the 'read-write' web, represents the second generation of the web wherein users not only consume information but also contribute to it. This version of the web facilitated user interaction and collaboration through platforms like social media and blogs.

## Web3.0

Known as the 'semantic' or 'decentralized' web, Web 3.0 refers to a future iteration of the World Wide Web that would be powered by artificial intelligence and machine learning. It would represent a significant shift from today's version toward a more decentralized web where data is linked, meaning it can be shared and reused across different platforms, applications, and domains.
