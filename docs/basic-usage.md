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

You can also deploy your contracts to the network running on the platform by executing the following command:

```shell
bunx settlemint scs hardhat deploy remote -m ignition/modules/main.ts
```

## Help

To get info about the tasks, run:

```shell
btp-scs --help
```
