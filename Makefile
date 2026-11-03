.DEFAULT_GOAL := status
.PHONY: pull up exec restart logs status ps start stop down rm new clean

COMPOSE_DIR_NEV := .
SERVICE :=
COMMAND :=

# Fetch the latest version of each service image in scope.
pull:
	@docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml config --images $(SERVICE) | sort -u | while read -r img; do docker pull "$$img"; done

up:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml up --detach $(SERVICE)

exec:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml exec $(SERVICE) $(COMMAND)

restart:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml restart $(SERVICE)

logs:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml logs -f $(SERVICE)

status: | ps

ps:
	@docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml ps

start:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml start $(SERVICE)

stop:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml stop $(SERVICE)

down:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml down $(SERVICE)

rm:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml rm --force --stop $(SERVICE)

new: | rm up

clean:
	docker compose --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml down --volumes --rmi local --remove-orphans
