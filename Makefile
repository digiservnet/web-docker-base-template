.PHONY: help

.DEFAULT_GOAL := help

define PRINT_HELP_PROLOGUE
   __                       __      __
  / /____  ____ ___  ____  / /___ _/ /____
 / __/ _ \/ __ `__ \/ __ \/ / __ `/ __/ _ \
/ /_/  __/ / / / / / /_/ / / /_/ / /_/  __/
\__/\___/_/ /_/ /_/ .___/_/\__,_/\__/\___/
                 /_/

Usage: make <command>

endef
export PRINT_HELP_PROLOGUE

help:  ## Show this help.
	@echo "$$PRINT_HELP_PROLOGUE\n"
	@echo "COMMANDS\n"
	@grep -E '^([a-zA-Z_-]+):.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "%-26s %s\n", $$1, $$2}'
	@echo ""

init: ## Initialise & configure the environment.
	@cp src/.env.example src/.env
	@docker compose up -d
	@docker compose exec --no-TTY --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php doppler secrets download --project TEMPLATE --token $(DOPPLER_TOKEN_APP_NAME) --config dev --format=env --no-file > src/.env
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php composer install
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan migrate
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan make:user
	@cd src; yarn; yarn dev

configure: ## (Re)configure an existing env vars.
	@docker compose exec --no-TTY --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php doppler secrets download --project TEMPLATE --token $(DOPPLER_TOKEN_APP_NAME) --config dev --format=env --no-file > src/.env

start: ## Start the dev environment.
	@docker compose up -d
	@cd src; yarn dev

stop: ## Stop the dev environment.
	@docker compose stop

kill: ## Destroy the dev environment.
	@docker compose down

shell: ## Gain shell access to the PHP container as the 'dockeruser' user.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php bash

root-shell: ## Gain shell access to the PHP container as the 'root' user.
	@docker compose exec -e XDEBUG_MODE=off -w /application/src TEMPLATE-php bash

db-migrate: ## Migrate the database.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan migrate

db-fresh: ## Migrate the database with a fresh schema.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan migrate:fresh

db-rollback: ## Rollback 'STEP=' number of migration steps
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan migrate:rollback "$(STEP)"

db-build: ## Migrate the database with a fresh schema and run the seeders.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan migrate:fresh
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan make:user
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan db:seed --class=RecruiterSeeder
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan db:seed --class=OpportunitySeeder

db-seed: ## Run the database seeders.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan db:seed --class=RecruiterSeeder
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan db:seed --class=OpportunitySeeder

scout-import:
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan scout:import "$(CLASS)"

back-update:
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php composer update

about: ## Show the application about screen.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan about

routes: ## List the application routes.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php php artisan route:list

back: ## Start the backend dev environment.
	@docker compose up -d

front: ## Start the frontend dev environment.
	@cd src; yarn dev

pint-test: ## Run Pint in test mode.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php vendor/bin/pint --test

pint-fix: ## Run Pint and fix issues.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php vendor/bin/pint

stan: ## Run static analysis.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php vendor/bin/phpstan

stan-baseline: ## Create a static analysis baseline file.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off -w /application/src TEMPLATE-php vendor/bin/phpstan --generate-baseline

# Queue
q-work: ## Start the queue worker.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan queue:work

q-listen: ## Start the queue worker in 'listen' mode (ideal for development).
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan queue:listen

horizon-start: # Start Horizon.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan horizon

horizon-pause: ## Pause Horizon.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan horizon:pause

horizon-continue: ## Un-pause Horizon.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan horizon:continue

horizon-status: ## Display the status of Horizon.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan horizon:status

horizon-kill: ## Terminate horizon.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan horizon:terminate

dev-scheduler: ## Run the Laravel scheduler for the worker.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan schedule:work

user: ## Create a new user.
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan make:user

clear-caches: ## Clear all of the Laravel caches (cache, route, view, config).
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan cache:clear
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan route:clear
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan view:clear
	@docker compose exec --user dockeruser -e XDEBUG_MODE=off TEMPLATE-php php artisan config:clear

clear-stan: ## Remove static analysis cache (ideal for permission issues).
	@docker compose exec -e XDEBUG_MODE=off TEMPLATE-php rm -rf /tmp/phpstan
