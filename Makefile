.DEFAULT_GOAL := status
.PHONY: pull build rebuild start exec restart logs status ps stop down rm new clean

COMPOSE_DIR_NEV := .
SERVICE :=
COMMAND :=

pull:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml pull $(SERVICE)

build:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml build $(SERVICE)

rebuild: | pull build

up:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml up --detach $(SERVICE)

exec:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml exec $(SERVICE) $(COMMAND)

restart:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml restart $(SERVICE)

logs:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml logs -f $(SERVICE)

status: | info ps

ps:
	@docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml ps

start:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml start $(SERVICE)

stop:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml stop $(SERVICE)

down:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml down $(SERVICE)

rm:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml rm --force --stop $(SERVICE)

new: | rm up

clean:
	docker-compose  --project-directory $(COMPOSE_DIR_NEV) --file $(COMPOSE_DIR_NEV)/docker-compose.yml down --volumes --rmi local --remove-orphans
