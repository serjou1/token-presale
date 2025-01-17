-include .env

deploy_on_sepolia_verify:; forge script script/DeployFlaryTokenSale.s.sol --rpc-url $(SEPOLIA_URL) --private-key $(OWNER_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv --legacy

deploy_on_sepolia:; forge script script/DeployFlaryTokenSale.s.sol --rpc-url $(SEPOLIA_URL) --private-key $(OWNER_PRIVATE_KEY) --broadcast -vvvv

deploy-mainnet:; forge script script/DeployFlaryTokenSale.s.sol --rpc-url $(MAINNER_URL) --private-key $(OWNER_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv --legacy

deploy-bsc:; forge script script/DeployFlaryTokenSale.s.sol --rpc-url $(BSC_URL) --private-key $(OWNER_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(BSCSCAN_API_KEY) -vvvv --legacy

