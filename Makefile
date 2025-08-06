CREATEX_DEPLOYER_PRIVATE_KEY=0x2a80cfc562233ec8b78f923f592f6fbaae78c3f3484896227bca901f09af5ad7
PROVIDER_RUL=http://127.0.0.1:8545

GETH_COMPOSE_RUN=docker compose -f geth-prysm/docker-compose.yml
RUNDLER_COMPOSE_RUN=docker compose -f bundler/docker-compose.yml

all: geth deploy/entry deploy/pm rundler pm

re-all: geth/force deploy/entry deploy/pm rundler/force pm

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

deploy/entry:
	@if ! docker image inspect deploy-entry-point >/dev/null 2>&1; then \
		echo "Building deploy-entry-point Docker image..."; \
		docker build -t deploy-entry-point ./deployEntryPoint; \
	fi
	@echo Deploying EntryPoint, SimpleAccount, SimpleAccountFactory ...
	@docker run --rm --network host deploy-entry-point deploy --network proxy

pm: deploy/pm deposit/pm server/pm

deploy/pm:
	@if ! docker image inspect deploy-paymaster >/dev/null 2>&1; then \
		echo "Building deploy-paymaster Docker image..."; \
		docker build -t deploy-paymaster ./deployPaymaster --no-cache; \
	fi
	@echo run deploy creatx
	@docker run --rm --network host deploy-paymaster deploy:creatx $(PROVIDER_RUL) $(CREATEX_DEPLOYER_PRIVATE_KEY)
	@docker run -e HARDHAT_IGNITION_CONFIRM_DEPLOYMENT=1 --rm --network host deploy-paymaster deploy -- --network localhost --strategy create2
	
deposit/pm:
	./cli.sh pm deposit

server/pm:
	@if ! docker image inspect simple-paymaster-server >/dev/null 2>&1; then \
		echo "Building simple-paymaster-server Docker image..."; \
		docker build -t simple-paymaster-server ./simplePaymasterServer; \
	fi
	@echo run simple-paymaster-server
	@docker run -d \
	--name simple-paymaster-server \
	-p 4001:4000 \
	-e BUNDLER_URL=http://host.docker.internal:3000 \
	-e PROVIDER_URL=http://host.docker.internal:8545 \
	-e PAYMASTER_ADDRESS=0x064Fbec1c03eC4004E7f9ADc5FAe2e2fB1857064 \
	-e PAYMASTER_PK=0xfefcc139ed357999ed60c6a013947328d52e7d9751e93fd0274a2bfae5cbcb12 \
	-e ENTRYPOINT_ADDRESS=0x0000000071727De22E5E9d8BAf0edAc6f37da032 \
	-e VERBOSITY=debug \
	-e PORT=4000 \
	simple-paymaster-server start