-include .env

DOCKER_REGISTRY=eoscostarica506
DOCKER_USERNAME=eoscostarica506
MIDDLEWARE_IMAGE_NAME=writer-node-middleware
MIDDLEWARE_VERSION ?= $(shell git ls-files -s ./src | git hash-object --stdin)

ifneq ("$(wildcard .env)", "")
	export $(shell sed 's/=.*//' .env)
endif

build-middleware: ##@devops Builds LACCHAIN MIDDLEWARE production docker image
build-middleware:
	@docker build \
		--target release \
		-t $(DOCKER_REGISTRY)/$(MIDDLEWARE_IMAGE_NAME):$(MIDDLEWARE_VERSION) \
		.

publish-middleware: ##@devops Publishes latest built docker image
publish-middleware:
	@echo $(DOCKER_PASSWORD) | docker login \
		--username $(DOCKER_USERNAME) \
		--password-stdin
	@docker push $(DOCKER_REGISTRY)/$(MIDDLEWARE_IMAGE_NAME):$(MIDDLEWARE_VERSION)
