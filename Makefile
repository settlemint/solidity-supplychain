# Makefile for Foundry Ethereum Development Toolkit

.PHONY: build test format snapshot anvil deploy deploy-anvil cast help subgraph clear_anvil_port

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
	@make clear_anvil_port
	@anvil

deploy-anvil:
	@echo "Deploying with Forge to Anvil..."
	@forge create ./src/ExampleSupplyChain.sol:ExampleSupplyChain --rpc-url anvil --interactive | tee deployment-anvil.txt

deploy-btp:
	@eval $$(curl -H "x-auth-token: $${BTP_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /'); \
	args=""; \
	if [ ! -z "$${BTP_FROM}" ]; then \
		args="--unlocked --from $${BTP_FROM}"; \
	else \
		echo "\033[1;33mWARNING: No keys are activated on the node, falling back to interactive mode...\033[0m"; \
		echo ""; \
		args="--interactive"; \
	fi; \
	if [ ! -z "$${BTP_GAS_PRICE}" ]; then \
		args="$$args --gas-price $${BTP_GAS_PRICE}"; \
	fi; \
	if [ "$${BTP_EIP_1559_ENABLED}" = "false" ]; then \
		args="$$args --legacy"; \
	fi; \
	forge create ./src/ExampleSupplyChain.sol:ExampleSupplyChain $${EXTRA_ARGS} --rpc-url $${BTP_RPC_URL} $$args | tee deployment.txt

script-anvil:
	@if [ ! -f deployment-anvil.txt ]; then \
		echo "\033[1;31mERROR: Contract was not deployed or the deployment-anvil.txt went missing.\033[0m"; \
		exit 1; \
	fi
	@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment-anvil.txt | awk '{print $$3}') forge script script/ExampleSupplyChain.sol:ExampleSupplyChain ${EXTRA_ARGS} --rpc-url anvil -i=1

script:
	@if [ ! -f deployment.txt ]; then \
		echo "\033[1;31mERROR: Contract was not deployed or the deployment.txt went missing.\033[0m"; \
		exit 1; \
	fi
	@eval $$(curl -H "x-auth-token: $${BTP_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /')
	@if [ -z "${ETH_FROM}" ]; then \
		echo "\033[1;33mWARNING: No keys are activated on the node, falling back to interactive mode...\033[0m"; \
		echo ""; \
		@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') forge script script/ExampleSupplyChain.sol:ExampleSupplyChain ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} -i=1; \
	else \
		@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') forge script script/ExampleSupplyChain.sol:ExampleSupplyChain ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} --unlocked; \
	fi

subgraph:
	@echo "Deploying the subgraph..."
	@rm -Rf subgraph/subgraph.config.json
	@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') TRANSACTION_HASH=$$(grep "Transaction hash:" deployment.txt | awk '{print $$3}') BLOCK_NUMBER=$$(cast receipt --rpc-url btp $${TRANSACTION_HASH} | grep "blockNumber" | awk '{print $$2}' | sed '2d') yq e -p=json -o=json '.datasources[0].address = env(DEPLOYED_ADDRESS) | .datasources[0].startBlock = env(BLOCK_NUMBER) | .chain = env(BTP_NODE_UNIQUE_NAME)' subgraph/subgraph.config.template.json > subgraph/subgraph.config.json
	@cd subgraph && npx graph-compiler --config subgraph.config.json --include node_modules/@openzeppelin/subgraphs/src/datasources ./datasources --export-schema --export-subgraph
	@cd subgraph && yq e '.specVersion = "0.0.4"' -i generated/solidity-supplychain.subgraph.yaml
	@cd subgraph && yq e '.description = "Solidity ExampleSupplyChain"' -i generated/solidity-supplychain.subgraph.yaml
	@cd subgraph && yq e '.repository = "https://github.com/settlemint/solidity-supplychain"' -i generated/solidity-supplychain.subgraph.yaml
	@cd subgraph && yq e '.features = ["nonFatalErrors", "fullTextSearch", "ipfsOnEthereumContracts"]' -i generated/solidity-supplychain.subgraph.yaml
	@cd subgraph && npx graph codegen generated/solidity-supplychain.subgraph.yaml
	@cd subgraph && npx graph build generated/solidity-supplychain.subgraph.yaml
	@eval $$(curl -H "x-auth-token: $${BTP_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /'); \
	if [ -z "$${BTP_MIDDLEWARE}" ]; then \
		echo "\033[1;31mERROR: You have not launched a graph middleware for this smart contract set, aborting...\033[0m"; \
		exit 1; \
	else \
		cd subgraph; \
		npx graph create --node $${BTP_MIDDLEWARE} $${BTP_SCS_NAME}; \
		npx graph deploy --version-label v1.0.$$(date +%s) --node $${BTP_MIDDLEWARE} --ipfs $${BTP_IPFS}/api/v0 $${BTP_SCS_NAME} generated/solidity-supplychain.subgraph.yaml; \
	fi

help:
	@echo "Forge help..."
	@forge --help
	@echo "Anvil help..."
	@anvil --help
	@echo "Cast help..."
	@cast --help

clear_anvil_port:
	-fuser -k -n tcp 8545