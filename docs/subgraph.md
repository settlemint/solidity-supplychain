# Subgraph Usage

## Deploy your subgraph

To index your smart contract events, use The Graph middleware.
First, edit `subgraph.config.json` to set the addresses of your smart contracts. You can find them in the deployment folder created under `ignation`. Then, run:

```shell
btp-scs subgraph deploy
```