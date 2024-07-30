<p align="center">
  <img src="https://github.com/settlemint/solidity-supplychain/blob/main/OG_Solidity.jpg"  align="center" alt="logo" />
  <h1 align="center">SettleMint Blockchain Transformation Platform Supplychain Smart Contract Set</h1>
  <p align="center">
    ✨ <a href="https://settlemint.com">https://settlemint.com</a> ✨
    <br/>
    Build a supplychain usecase in the SettleMint Blockchain Transformation Platform with ease.
  </p>
</p>
<br/>
<p align="center">
<a href="https://github.com/settlemint/solidity-supplychain/actions?query=branch%3Amain"><img src="https://github.com/settlemint/solidity-supplychain/actions/workflows/solidity.yml/badge.svg?event=push&branch=main" alt="CI status" /></a>
<a href="https://opensource.org/licenses/MIT" rel="nofollow"><img src="https://img.shields.io/github/license/settlemint/solidity-supplychain" alt="License"></a>
<a href="https://github.com/settlemint/solidity-supplychain" rel="nofollow"><img src="https://img.shields.io/github/stars/settlemint/solidity-supplychain" alt="stars"></a>
</p>

<div align="center">
  <a href="https://console.settlemint.com/documentation/">Documentation</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://discord.com/invite/Mt5yqFrey9">Discord</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://github.com/settlemint/solidity-supplychain/issues">Issues</a>
  <br />
</div>

## Get started

Launch this smart contract set in the SettleMint Blockchain Transformation platform under the `Smart Contract Sets` section. This will automatically link it to your own blockchain node and make use of the private keys living in the platform.

If you want to use it separately, bootstrap a new project using

```shell
forge init my-erc20-token --template settlemint/solidity-token-erc20
```

## DX: Foundry & Hardhat hybrid

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

**Hardhat is a Flexible, Extensible, Fast Ethereum development environment for professionals in typescript**

Hardhat consists of:

- **Hardhat Runner**: Hardhat Runner is the main component you interact with when using Hardhat. It's a flexible and extensible task runner that helps you manage and automate the recurring tasks inherent to developing smart contracts and dApps.
- **Hardhat Ignition**: Declarative deployment system that enables you to deploy your smart contracts without navigating the mechanics of the deployment process.
- **Hardhat Network**: Declarative deployment system that enables you to deploy your smart contracts without navigating the mechanics of the deployment process.

## Documentation

- <https://console.settlemint.com/documentation/docs/using-platform/integrated-development-environment/>
- <https://book.getfoundry.sh/>

## Usage

### Build

You can either use Forge:

```shell
btp-scs foundry build
```

or Hardhat:

```shell
btp-scs hardhat build
```

### Test

With Forge:

```shell
btp-scs foundry test
```

or Hardhat:

```shell
btp-scs hardhat test
```

### Format

To format your contracts, run

```shell
btp-scs foundry format
```

### Deploy to local network

You can deploy your contracts to a local network. First, run

```shell
btp-scs hardhat network
```

then:

```shell
btp-scs hardhat deploy local -m ignition/modules/main.ts
```

### Deploy to platform network

You can also deploy your contracts to the network running on the platform by executing the following command:

```shell
btp-scs hardhat deploy remote -m ignition/modules/main.ts
```

### Deploy your subgraph

To index your smart contract events, use The Graph middleware.
First, edit `subgraph.config.json` to set the addresses of your smart contracts. You can find them in the deployment folder created under `ignation`. Then, run:

```shell
btp-scs subgraph deploy
```

### Help

To get info about the tasks, run:

```shell
btp-scs --help
```
