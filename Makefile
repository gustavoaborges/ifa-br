### Defensive settings for make:
#     https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
.SHELLFLAGS:=-xeu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

.PHONY: all
all: build

.PHONY: build
build:
	@echo "Montando sistema... zueira, isso aqui faz nada"

.PHONY: build-frontend
build-frontend:
	docker build -t ifa-br-frontend-image frontend/.
	docker tag ifa-br-frontend-image:latest gustavoaborges/ifa-br-frontend:latest
	docker push gustavoaborges/ifa-br-frontend:latest

.PHONY: backup-db
backup-db:
	ssh root@$(server) "(docker run --rm --volumes-from ifa-br_db_1 -v ~:/backup busybox tar cvfz /backup/backup.tar /data)"
	scp root@$(server):~/backup.tar ./backup.tar

.PHONY: restore-db
restore-db:
	scp ./backup.tar root@$(server):~/backup.tar
	ssh root@$(server) "(docker run --rm --volumes-from ifa-br_db_1 -v ~:/backup busybox sh -c \"cd /data && tar xvf /backup/backup.tar --strip 1\"; cd ifa-br; docker-compose down && docker-compose up -d)"