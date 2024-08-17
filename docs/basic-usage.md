# Basic Usage

## Build

You can either use Forge:

```shell
btp-scs foundry build
```

or Hardhat:

```shell
btp-scs hardhat build
```

## Test

With Forge:

```shell
btp-scs foundry test
```

or Hardhat:

```shell
btp-scs hardhat test
```

## Format

To format your contracts, run

```shell
btp-scs foundry format
```

## Deploy to local network

You can deploy your contracts to a local network. First, run

```shell
btp-scs hardhat network
```

then:

```shell
btp-scs hardhat deploy local -m ignition/modules/main.ts
```

## Deploy to platform network

You can also deploy your contracts to the network running on the platform by executing the following command:

```shell
btp-scs hardhat deploy remote -m ignition/modules/main.ts
```

## Help

To get info about the tasks, run:

```shell
btp-scs --help
```
