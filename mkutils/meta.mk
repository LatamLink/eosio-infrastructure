-include .env
VERSION ?= $(shell git ls-files -s ./ configs | git hash-object --stdin)
IMAGE_NAME=eosio-nodeos
CDT_IMAGE_NAME=eosio-cdt-nodeos
DOCKER_REGISTRY=eoscostarica506
MAKE_ENV += VERSION IMAGE_NAME CDT_IMAGE_NAME DOCKER_REGISTRY 

SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))')
#K8S_BUILD_DIR ?= ./build_k8s
#K8S_FILES := $(shell find ./kubernetes -name '*.yml' | sed 's:./kubernetes/::g')

ifneq ("$(wildcard .env)", "")
	export $(shell sed 's/=.*//' .env)
endif
