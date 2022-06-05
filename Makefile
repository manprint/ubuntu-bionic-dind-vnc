.PHONY: help

TITLE_MAKEFILE=Kasm Ubuntu Bionic

SHELL=/bin/bash
.SHELLFLAGS += -o pipefail
.ONESHELL:

export CURRENT_DIR := $(shell pwd)
export RED := $(shell tput setaf 1)
export RESET := $(shell tput sgr0)
export DATE_NOW := $(shell date)

IMAGE := "kasmweb/core-ubuntu-bionic:1.10.1"

.DEFAULT := help

help:
	@printf "\n$(RED)$(TITLE_MAKEFILE)$(RESET)\n"
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo

##@ Build

build: ## Build Image
	@docker build --rm --force-rm --tag ${IMAGE} .
