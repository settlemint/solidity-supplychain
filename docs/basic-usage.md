# Basic Usage

## Build

You can either use Forge:

```shell
bunx settlemint scs foundry build
```

or Hardhat:

```shell
bunx settlemint scs hardhat build
```

## Test

With Forge:

```shell
bunx settlemint scs foundry test
```

or Hardhat:

```shell
bunx settlemint scs hardhat test
```

## Format

To format your contracts, run

```shell
bunx settlemint scs foundry format
```

## Deploy to local network

You can deploy your contracts to a local network. First, run

```shell
bunx settlemint scs hardhat network
```

then:

```shell
bunx settlemint scs hardhat deploy local -m ignition/modules/main.ts
```

## Deploy to platform network

To deploy your contracts to the platform network, first log in using the SDK:

```shell
bunx settlemint login
```

You only need to run this `login` command once.

Then, you can deploy your contracts using the following command:

```shell
bunx settlemint scs hardhat deploy remote -m ignition/modules/main.ts
```

## Help

To get info about the tasks, run:

```shell
bunx settlemint scs --help
```
