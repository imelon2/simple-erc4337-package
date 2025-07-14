

# Overview
This repository is an all-in-one local development environment for experimenting with **[ERC-4337](https://eips.ethereum.org/EIPS/eip-4337)** account abstraction on Ethereum for end-to-end testing. </br>
This setup is ideal for developers who want to:

- Understand how ERC-4337 components interact in practice
- Prototype and debug new smart accounts and paymasters
- Develop, test, or demo new bundler or wallet features in a local, reproducible environment

Whether you are building **smart wallets**, paymasters, bundler, or simply want to learn more about account abstraction, this package provides a streamlined foundation for rapid development and experimentation.

> [!IMPORTANT] 
> **ERC-4337 Entry Point Version Support**
> This package is designed to be fully compatible with [EntryPoint v0.7.0](https://github.com/eth-infinitism/account-abstraction/tree/v0.7.0), and all contracts and scripts work seamlessly with this version’s ERC-4337 features and [specifications](https://github.com/eth-infinitism/account-abstraction/releases).


## Features
- Build a local **[Geth](https://github.com/ethereum/go-ethereum) & [Prysm](https://github.com/OffchainLabs/prysm) POS node**.
- Build bundler using **[Alchemy Rundler](https://github.com/alchemyplatform/rundler)**.
- Deploy `EntryPoint.sol`, `SimpleAccount.sol`, `SimpleAccountFactory.sol` by **[eth-infinitism/account-abstraction](https://github.com/eth-infinitism/account-abstraction/tree/v0.7.0)**.
- Deploy `VerifyingPaymaster.sol` using **[imelon2/simple-paymaster-contract](https://github.com/imelon2/simple-paymaster-contract)** and interact with paymaster contracts using the `forge cast` CLI tool.
- Build **simple Paymaster server based [ERC-7677](https://eips.ethereum.org/EIPS/eip-7677)** for gas sponsorship using **[imelon2/simple-paymaster-server](https://github.com/imelon2/simple-paymaster-server)**.
- Execute script for *create UserOp* and *call bundler, paymaster RPC* using **[Viem](https://viem.sh/account-abstraction)**.

## Requirement
TODO....

## RPC Info
| Service       | URL                         |
| ------------- | --------------------------- |
| Node RPC      | `http://localhost:8545`     |
| Bundler RPC*  | `http://localhost:3000/rpc` |
| Paymaster API | `http://localhost:3500`     |


## Address Info
### Account
| name                 	| address                                    	| private key                                                        	|
|----------------------	|--------------------------------------------	|--------------------------------------------------------------------	|
| entry point deployer 	| 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 	| 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 	|
| paymaster deployer 	| 0x55511cFf14093Cd85a3c36Ad3527369cBc8a5063 	| 0xfefcc139ed357999ed60c6a013947328d52e7d9751e93fd0274a2bfae5cbcb12 	|
| Bundler 1            	| 0xaa69F1B45a1d188185ff1143798DCa67d62DE013 	| 0xc9d3cc38292cb0185be663e028428796616c4d90569f3ba7f50358f6324fbd4c 	|
| Bundler 2            	| 0xbbbc946162687CdC6Ca4B72DA89809f68857f880 	| 0x7575962aed3d3f712a0dd3d9255dee8a4f6e0a812415a8e8dd06d67ea2d233ca 	|
| User 1              	| 0x4337E2176caca2eead8Da81046eB7be30B12BA3a 	| 0x2a80cfc562233ec8b78f923f592f6fbaae78c3f3484896227bca901f09af5ad7 	|

### Contract
| name                 	| address                                    	|
|----------------------	|--------------------------------------------	|
| EntryPoint v0.7.0    	| 0x0000000071727De22E5E9d8BAf0edAc6f37da032 	|
| Paymaster            	| 0x064Fbec1c03eC4004E7f9ADc5FAe2e2fB1857064 	|
| SimpleAccountFactory 	| 0x91E60e0613810449d098b0b5Ec8b51A0FE8c8985 	|
| CreateX              	| 0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed 	|