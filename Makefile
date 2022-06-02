# Minimal makefile for containerized SLATE Remote Client
#

# Variables
IMAGENAME = slate-remote-client
IMAGETAG = $(IMAGENAME):local
VERSION = "0.0.6"

# Targets

build:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGETAG) .

build-nocache:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGETAG) --no-cache .

clean:
	docker image rm $(IMAGETAG) -f
	docker container rm $(IMAGENAME)-dev
	docker container rm $(IMAGENAME)-prod
	docker container rm $(IMAGENAME)-staging

dev: build
	(docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG)) || \
	(echo "Removing old containers....................................................." && \
	  docker container rm $(IMAGENAME)-$@ && \
      docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG))

prod: build
	(docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG)) || \
	(echo "Removing old containers....................................................." && \
	  docker container rm $(IMAGENAME)-$@ && \
      docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG))

staging: build
	(docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG)) || \
	(echo "Removing old containers....................................................." && \
	  docker container rm $(IMAGENAME)-$@ && \
      docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGETAG))
