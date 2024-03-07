# Makefile for Foundry Ethereum Development Toolkit

.PHONY: build test format snapshot anvil deploy deploy-anvil cast help subgraph

build:
	@echo "Building with Forge..."
	@forge build

test:
	@echo "Testing with Forge..."
	@forge test

format:
	@echo "Formatting with Forge..."
	@forge fmt

snapshot:
	@echo "Creating gas snapshot with Forge..."
	@forge snapshot

anvil:
	@echo "Starting Anvil local Ethereum node..."
	@anvil

deploy-anvil:
	@echo "Deploying with Forge to Anvil..."
	@forge create ./src/Counter.sol:Counter --rpc-url anvil --interactive | tee deployment-anvil.txt

deploy:
	@eval $$(curl -H "x-auth-token: $${BPT_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /')
	@if [ -z "${ETH_FROM}" ]; then \
		echo "\033[1;33mWARNING: No keys are activated on the node, falling back to interactive mode...\033[0m"; \
		echo ""; \
		forge create ./src/Counter.sol:Counter ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} --interactive | tee deployment.txt; \
	else \
		forge create ./src/Counter.sol:Counter ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} --unlocked | tee deployment.txt; \
	fi

script-anvil:
	@if [ ! -f deployment-anvil.txt ]; then \
		echo "\033[1;31mERROR: Contract was not deployed or the deployment-anvil.txt went missing.\033[0m"; \
		exit 1; \
	fi
	@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment-anvil.txt | awk '{print $$3}') forge script script/Counter.s.sol:CounterScript ${EXTRA_ARGS} --rpc-url anvil -i=1

script:
	@if [ ! -f deployment-anvil.txt ]; then \
		echo "\033[1;31mERROR: Contract was not deployed or the deployment-anvil.txt went missing.\033[0m"; \
		exit 1; \
	fi
	@eval $$(curl -H "x-auth-token: $${BPT_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /')
	@if [ -z "${ETH_FROM}" ]; then \
		echo "\033[1;33mWARNING: No keys are activated on the node, falling back to interactive mode...\033[0m"; \
		echo ""; \
		@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') forge script script/Counter.s.sol:CounterScript ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} -i=1; \
	else \
		@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') forge script script/Counter.s.sol:CounterScript ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} --unlocked; \
	fi

cast:
	@echo "Interacting with EVM via Cast..."
	@cast $(SUBCOMMAND)

subgraph:
	@echo "Deploying the subgraph..."
	@rm -Rf subgraph/subgraph.config.json
	@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') yq e -p=json -o=json '.datasources[0].address = env(DEPLOYED_ADDRESS) | .chain = env(BTP_NETWORK_NAME)' subgraph/subgraph.config.template.json > subgraph/subgraph.config.json
	@cd subgraph
	@pnpm graph-compiler --config subgraph.config.json --include node_modules/@openzeppelin/subgraphs/src/datasources subgraph/datasources --export-schema --export-subgraph
	@yq e '.specVersion = "0.0.4"' -i generated/solidity-token-erc20.subgraph.yaml
	@yq e '.description = "Solidity Token ERC20"' -i generated/solidity-token-erc20.subgraph.yaml
	@yq e '.repository = "https://github.com/settlemint/solidity-token-erc20"' -i generated/solidity-token-erc20.subgraph.yaml
	@yq e '.indexerHints.prune = "auto"' -i generated/solidity-token-erc20.subgraph.yaml
	@yq e '.features = ["nonFatalErrors", "fullTextSearch", "ipfsOnEthereumContracts"]' -i generated/solidity-token-erc20.subgraph.yaml
	@pnpm graph codegen generated/solidity-token-erc20.subgraph.yaml
	@pnpm graph build generated/solidity-token-erc20.subgraph.yaml
	@eval $$(curl -H "x-auth-token: $${BPT_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /')
	@if [ "$${BTP_MIDDLEWARE}" == "" ]; then \
		echo "You have not launched a graph middleware for this smart contract set, aborting..."; \
		exit 1; \
	else \
		pnpm graph create --node $${BTP_MIDDLEWARE} $${BTP_SCS_NAME}; \
		pnpm graph deploy --version-label v1.0.$$(date +%s) --node $${BTP_MIDDLEWARE} --ipfs $${BTP_IPFS}/api/v0 $${BTP_SCS_NAME} generated/solidity-token-erc20.subgraph.yaml; \
	fi

help:
	@echo "Forge help..."
	@forge --help
	@echo "Anvil help..."
	@anvil --help
	@echo "Cast help..."
	@cast --help
