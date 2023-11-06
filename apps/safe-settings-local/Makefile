.DEFAULT_GOAL := help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  up        Start the Docker Compose service"
	@echo "  down      Stop the Docker Compose service"
	@echo "  logs      View the logs of the Docker Compose service"
	@echo "  shell     Open a shell in the Docker Compose service"
	@echo "  open      Share the service to internet (through ngrok) to be able to receive webhooks from GitHub"
	@echo "  help      Show this help message"

up: CMD=up -d
stop down: CMD=down
restart: CMD=restart
logs: CMD=logs -f $(DOCKER_COMPOSE_SERVICE)
shell: CMD=exec $(DOCKER_COMPOSE_SERVICE) sh
up down stop restart logs shell:
	@docker compose -f docker-compose.yml $(CMD)
open:
	@ngrok http 3000
