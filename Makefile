CONTAINER_RUNTIME="/usr/bin/crun"

# squash-all, squash, layers
BUILD_MODE ?= squash-all
# newer, missing, always, never
PULL_POLICY ?= newer
NO_CACHE=false

# squash-all, squash, layers
BUILD_MODE ?= squash-all
PULL_POLICY ?= newer

all: build

.PHONY: image
image:
	podman build \
		--runtime="$(CONTAINER_RUNTIME)" \
		--$(BUILD_MODE) \
		--pull="$(PULL_POLICY)" \
		--no-cache="$(NO_CACHE)" \
		-t build-freetube \
		-f Containerfile \
			container

.PHONY: build
build: image
	mkdir -p /tmp/build-freetube/out
	podman run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
			build-freetube
	echo "install with \`dpkg -i /tmp/build-freetube/out/*.deb\`"

.PHONY: install
install: build
	sudo dpkg -i /tmp/build-freetube/out/*.deb \
		&& rm -rf /tmp/build-freetube

.PHONY: interactive
interactive: image
	mkdir -p /tmp/build-freetube/out
	podman run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
		--entrypoint bash \
			build-freetube

.PHONY: help
help:
	@grep '^[a-zA-Z\-_0-9].*:' Makefile | cut -d : -f 1 | sort
