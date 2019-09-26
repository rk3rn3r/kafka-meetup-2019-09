.DEFAULT_GOAL := help
.PHONY: help run stop

help:
	@echo ''
	@echo "Oooops... nothing to see here ;)"
	@echo ''

APP_NAME ?= "tracking-demo"

KEYS := build exec

define LOOPBODY
  ifneq ($$(filter $$(KEYS),$(v)),)
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
  endif
endef

$(foreach v,$(firstword $(MAKECMDGOALS)),$(eval $(LOOPBODY)))

## Commands ##
startup:
	@cp -n .env.dist .env || true
	@cp -n docker-compose.override.dist.yml docker-compose.override.yml || true
	@docker-compose -p ${APP_NAME} stop
	@docker-compose -p ${APP_NAME} rm -f
	docker-compose -p ${APP_NAME} build --pull
	docker-compose -p ${APP_NAME} up -d --force-recreate

waitforkcd:
	@echo "Waiting for Kafka Connect Distributed (KCD) REST API to become available..."
	@bash -c 'CNT=1 ; RES=1 ; while [[ "$${RES}" -ne 0 ]] && [[ "$${CNT}" -le 150 ]] ; do sleep 2 ; curl -X GET -H "Accept: application/json" "http://localhost:28083/connectors" > /dev/null 2>&1 ; RES="$$?" ; ((CNT++)) ; done'
	@sleep 5
	@echo

start: startup waitforkcd connectorstart

createtopics:
	@docker-compose -p $(APP_NAME) exec meetup201909-connect /tmp/kafka-scripts/create-topics.sh

listtopics:
	docker-compose -p $(APP_NAME) exec meetup201909-connect bash -c 'kafka-topics --bootstrap-server $${BOOTSTRAP_SERVERS} --list'

webserver:
	scripts/server.py 8080

connectorstart:
	curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d @config/tracking-http-sink.json "http://localhost:28083/connectors"
	@echo

connectorstop:
	curl -X DELETE -H "Accept: application/json" "http://localhost:28083/connectors/tracking-http-sink-meetup201909" || true
	@echo

stop: connectorstop
	docker-compose -p ${APP_NAME} stop
	docker-compose -p ${APP_NAME} rm -f

exec:
	docker-compose -p $(APP_NAME) exec $(RUN_ARGS)

connectorstatus:
	curl -X GET -H "Accept: application/json" "http://localhost:28083/connectors/tracking-http-sink-meetup201909/status"
	@echo

trackinglog:
	docker-compose -p $(APP_NAME) exec meetup201909-connect bash -c 'kafka-console-consumer --bootstrap-server $${BOOTSTRAP_SERVERS} --property print.timestamp=true --property print.key=true --from-beginning --whitelist "$${TRACKING_TOPICS/,/|}"'

sendbatch:
	bash ./scripts/batch_test.sh
	@echo

dump-config:
	docker-compose config
%:
@:
