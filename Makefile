# Minimal makefile for containerized SLATE Remote Client
#

# Variables
ENVS = dev devOld staging prod
IMAGENAME = slate-remote-client
IMAGETAG = local
VERSION = "1.0.21"

# Targets

build:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGENAME):$(IMAGETAG) .

build-nocache:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGENAME):$(IMAGETAG) --no-cache .

clean:
	docker image rm $(IMAGENAME):$(IMAGETAG) -f

$(ENVS): build
	(docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGENAME):$(IMAGETAG)) || \
	(echo "Removing old containers....................................................." && \
	  docker container rm $(IMAGENAME)-$@ && \
      docker run -it \
		-v ${PWD}/work:/work:Z \
		--env SLATE_ENV=$@ \
		--name $(IMAGENAME)-$@ \
		$(IMAGENAME):$(IMAGETAG))
