TAG = rvannauker/php
VERSION = 1.0.0
FILE_NAME = php.dockerfile
DESTINATION = .
DEBUG_COMMAND = /bin/sh
MICROBADGE_HOOK_URL = https://hooks.microbadger.com/images/rvannauker/php/EV9KoAKQBjH6W_Qx9oz7m5ezgqI=

.PHONY: default build build_latest push run debug microbadge_hook release

default: build

build:
	docker build \
	       --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
	       --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
	       --build-arg VERSION="$(VERSION)" \
	       --force-rm \
	       --tag "$(TAG):$(VERSION)" \
	       --file "$(FILE_NAME)" \
	       $$PWD

build_latest:
	docker build \
	       --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
	       --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
	       --build-arg VERSION="latest" \
	       --force-rm \
	       --tag "$(TAG):latest" \
	       --file "$(FILE_NAME)" \
	       $$PWD

push:
	docker push $(TAG)

run:
	@docker run \
	       --rm \
           --volume $$PWD:/workspace \
           --name "php" \
           "$(TAG):$(VERSION)" \
           $(DESTINATION)

debug:
	docker run \
	       --rm \
	       --interactive \
	       "$(TAG):$(VERSION)" $(DEBUG_COMMAND)

microbadge_hook:
	curl -X POST $(MICROBADGE_HOOK_URL)

release: build build_latest push microbadge_hook