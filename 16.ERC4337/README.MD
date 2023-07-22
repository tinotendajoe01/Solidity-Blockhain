WHY WE NEED ACCOUNT ABSTRACT

hiding the wires

-self custody: is hard we need soluttion for this
-givng custody to another entity

EOA AND CA- account state
EOA
-nonce and balance present, storage hash and code hash empyt
-controled by private key, no evm code

CA
-nonce and balance , storage hash and code hash empytpresent
-evm byey code

EOS problem
-no way to recovr funds
-users cant make mistakes -lost passworda
-ECDSA algorithm is not quantum proof

- not good for mainstreem adoption

why we need account abstraction
-koramangala effect

- users will only engage if there is economic sense
  -ui/ux if problem, complex steps a user must do ..

AA- every account is smart contract that can contain and implement flow
-separating the accc from the blockchain
-smart accounts

EIP4337
AA via entry point contract specification
-no need to do protocol changes
-geting rid of eos
-creation separate mempool
smart contract acc---userops mempool- node- entrypoint contract    ---blockchain
                                                                   =                
smart contract acc---userops mempool- bulndler- entrypoint contract    ---blockchain


5 major components
useroperations
useroperations mempool
bundler
entry point
agreegators
paymasters


userOps
-pseudo trans objects rep users intent
-ABI encoded
-not allowed to access any information that alter current blocktime number, hash
- only allowed to access data related to sender address
-not identified as a regular transaction

userop mempool
-

Bundler
-can be a node that listens to the mempool ,and bunldes multiple user ops. can be like a blockcbuilder but not all blockbuilders on the network require to be bundlers
-

Entrypoint - singleton contract
-global contract to validate and execute user op
-two phase: verificatiob loop and execution loop

Paymaster
-agree to sponsor a transactiob for an accoun
- allow to pay fees with erc20 tokens

Aggregator
-ACC CAN USE SIGNATURE AGGREGATORS TO REDUCE MANY SIGNATURES INTO ONE
