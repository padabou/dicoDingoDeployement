# Makefile for docker

IMAGE_NAME_ADMIN = padabou/dicodingo-admin
IMAGE_NAME_WEBSITE = padabou/dicodingo-website
IMAGE_NAME_BACKEND = padabou/dicodingo-backend

VERSION := "latest"

ifdef $$VERSION
VERSION := $$VERSION
endif

# If this commit have been tagged, set IMAGE_VERSION with it
GIT_TAG ?= $(shell git tag -l --points-at HEAD | head -n1)
# If not, tag this image 'latest'
IMAGE_VERSION := $(if $(GIT_TAG),$(GIT_TAG),latest)

# -----------------------------------------------------------------
#        Main targets
# -----------------------------------------------------------------

help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m\t%s\n", $$1, $$2}'

version: ## version
	@echo "$(IMAGE_NAME):$(IMAGE_VERSION) , git tag : $(GIT_TAG)"

build-backend: ## create backend image, run "make VERSION="1.1.0" build-backend"
	cd ../dicoDingoBack && mvn clean install -DskipTests && docker build --no-cache -t $(IMAGE_NAME_BACKEND):$(VERSION) -f Dockerfile .

push-backend-latest: ## push latest backend docker image to docker.io
	docker push $(IMAGE_NAME_BACKEND):$(VERSION)

build-admin: ## create admin image, run "make VERSION="1.1.0" build-admin"
	cd ../dicoDingoAdmin && docker build --no-cache -t $(IMAGE_NAME_ADMIN):$(VERSION) -f Dockerfile .

push-admin-latest: ## push latest admin docker image to docker.io
	docker push $(IMAGE_NAME_ADMIN):$(VERSION)

build-front: ## create front image, run "make VERSION="1.1.0" build-front"
	cd ../dicoDingoFront && docker build --no-cache -t $(IMAGE_NAME_WEBSITE):$(VERSION) -f Dockerfile .

push-front-latest: ## push latest website docker image to docker.io
	docker push $(IMAGE_NAME_WEBSITE):$(VERSION)

build: ## create the image
	mvn clean install -DskipTests
	docker build --no-cache -t $(IMAGE_NAME_ADMIN):latest -f admin/docker/Dockerfile .
	docker build --no-cache -t $(IMAGE_NAME_WEBSITE):latest -f website/docker/Dockerfile .
	## set the native image build command

push: build ## build and push image
	docker tag $(IMAGE_NAME_ADMIN):latest $(IMAGE_NAME_ADMIN):$(IMAGE_VERSION)
	docker tag $(IMAGE_NAME_WEBSITE):latest $(IMAGE_NAME_WEBSITE):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME_ADMIN):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME_WEBSITE):$(IMAGE_VERSION)

run: ## create a new container from the image
	docker run -p 8080:8080 -p 8081:8081 -d $(IMAGE_NAME_ADMIN):latest

start-app-backend: ## start backend application in docker image
	docker-compose up app-backend -d

start-app-admin: ## start admin application in docker image
	docker-compose up app-admin -d

start-app-website: ## start website application in docker image
	docker-compose up app-website -d

start-db: ## start database
	docker-compose up mongo -d

start-all: ## start front back admin and bdd
	docker-compose up -d