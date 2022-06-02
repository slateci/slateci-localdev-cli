# Minimal makefile for containerized SLATE Remote Client

build-cli:
	docker build --file ./Dockerfile --tag slate-remote-client:local .

cli-dev:
	docker run -it -v ${PWD}/work:/work --env SLATE_ENV=dev --name slate-remote-client-dev slate-remote-client:local

cli-staging:
	docker run -it -v ${PWD}/work:/work --env SLATE_ENV=staging --name slate-remote-client-staging slate-remote-client:local

cli-prod:
	docker run -it -v ${PWD}/work:/work --env SLATE_ENV=prod --name slate-remote-client-prod slate-remote-client:local

clean:
	docker image rm slate-remote-client:local -f