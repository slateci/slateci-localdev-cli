# Minimal makefile for containerized SLATE Remote Client
#

# Variables
ENVS = dev devOld staging prod
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

$(ENVS): build
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
