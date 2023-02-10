# Minimal makefile for containerized SLATE Remote Client
#

# Variables
ENVS = local dev staging prod prod2
IMAGENAME = slate-remote-client
IMAGETAG = local
VERSION="latest"

# Targets

build:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGENAME):$(IMAGETAG) .

build-nocache:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGENAME):$(IMAGETAG) --no-cache .

clean:
	docker image rm $(IMAGENAME):$(IMAGETAG) -f

$(ENVS): build-nocache
	(docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		--network="host" \
		$(IMAGENAME):$(IMAGETAG)) || \
	(echo "Removing old containers....................................................." && \
	  docker container rm $(IMAGENAME)-$@ && \
      docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		--network="host" \
		$(IMAGENAME):$(IMAGETAG))
