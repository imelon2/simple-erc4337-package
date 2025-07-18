CREATEX_DEPLOYER_PRIVATE_KEY=0x2a80cfc562233ec8b78f923f592f6fbaae78c3f3484896227bca901f09af5ad7
PROVIDER_RUL=http://127.0.0.1:8545

GETH_COMPOSE_RUN=docker compose -f geth-prysm/docker-compose.yml
RUNDLER_COMPOSE_RUN=docker compose -f bundler/docker-compose.yml

all: geth deploy rundler

re-all: geth/force deploy rundler/force

geth:
	@echo Building geth node...
	@$(GETH_COMPOSE_RUN) up -d > /dev/null 2>&1

geth/force:
	@echo Down geth node...
	@$(GETH_COMPOSE_RUN) down > /dev/null 2>&1
	@echo Reset geth node DB...
	@./geth-prysm/launcher.sh clean > /dev/null 2>&1
	@echo Re-Building geth node...
	@$(GETH_COMPOSE_RUN) up -d > /dev/null 2>&1

rundler:
	@echo Building bundler using rundler...
	@$(RUNDLER_COMPOSE_RUN) up -d > /dev/null 2>&1

rundler/force:
	@echo Down bundler server...
	@$(RUNDLER_COMPOSE_RUN) down > /dev/null 2>&1
	@echo Building bundler using rundler...
	@$(RUNDLER_COMPOSE_RUN) up -d > /dev/null 2>&1

deploy: deploy/entry deploy/pm


deploy/entry:
	@if ! docker image inspect deploy-entry-point >/dev/null 2>&1; then \
		echo "Building deploy-entry-point Docker image..."; \
		docker build -t deploy-entry-point ./deployEntryPoint; \
	fi
	@echo Deploying EntryPoint, SimpleAccount, SimpleAccountFactory ...
	@docker run --rm --network host deploy-entry-point deploy --network proxy

deploy/pm:
	@if ! docker image inspect deploy-paymaster >/dev/null 2>&1; then \
		echo "Building deploy-paymaster Docker image..."; \
		docker build -t deploy-paymaster ./deployPaymaster --no-cache; \
	fi
	@echo run deploy creatx
	@docker run --rm --network host deploy-paymaster deploy:creatx $(PROVIDER_RUL) $(CREATEX_DEPLOYER_PRIVATE_KEY)
	@docker run -e HARDHAT_IGNITION_CONFIRM_DEPLOYMENT=1 --rm --network host deploy-paymaster deploy -- --network localhost --strategy create2
	