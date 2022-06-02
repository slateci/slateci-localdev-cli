# Minimal makefile for containerized SLATE Remote Client
#

# Variables
IMAGETAG = "slate-remote-client:local"
VERSION = "0.0.6"

# Targets

build:
	docker build --file ./Dockerfile --build-arg slateclientversion=$(VERSION) --tag $(IMAGETAG) .

cli-dev: build
	docker container rm slate-remote-client-dev
	docker run -it \
      -v ${PWD}/work:/work:Z \
      --env SLATE_ENV=dev \
      --name slate-remote-client-dev \
      $(IMAGETAG)

cli-prod: build
	docker container rm slate-remote-client-prod
	docker run -it \
	  -v ${PWD}/work:/work:Z \
	  --env SLATE_ENV=prod \
	  --name slate-remote-client-prod \
	  $(IMAGETAG)

cli-staging: build
	docker container rm slate-remote-client-staging
	docker run -it \
	  -v ${PWD}/work:/work:Z \
	  --env SLATE_ENV=staging \
	  --name slate-remote-client-staging \
	  $(IMAGETAG)

clean:
	docker image rm $(IMAGETAG) -f
	docker container rm slate-remote-client-dev
	docker container rm slate-remote-client-prod
	docker container rm slate-remote-client-staging
