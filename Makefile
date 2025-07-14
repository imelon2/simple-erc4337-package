GETH_COMPOSE_RUN=docker compose -f geth-prysm/docker-compose.yml
RUNDLER_COMPOSE_RUN=docker compose -f bundler/docker-compose.yml


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

deploy:

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
		docker build -t deploy-paymaster ./deployPaymaster; \
	fi
	@echo run deploy creatx
	@docker run --rm --network host deploy-paymaster deploy:creatx http://127.0.0.1:8545 0xfefcc139ed357999ed60c6a013947328d52e7d9751e93fd0274a2bfae5cbcb12
	@docker run --rm --network host deploy-paymaster deploy -- --network localhost --strategy create2


rundler:
	@echo Building bundler using rundler...
	@$(RUNDLER_COMPOSE_RUN) up -d > /dev/null 2>&1