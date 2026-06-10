IMAGE_NAME=build-freetube
IMAGE_TAG=latest

# squash-all, squash, layers
BUILD_MODE ?= squash
# newer, missing, always, never
PULL_POLICY ?= newer
NO_CACHE=false

BUILD_DIR ?= /tmp/$(IMAGE_NAME)
SRC_DIR=container

CONTAINER_RUNTIME="/usr/bin/crun"

all: build

.PHONY: clean
clean:
	rm -rf "$(BUILD_DIR)/"
	"$(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: image
image:
	podman build \
		--runtime="$(CONTAINER_RUNTIME)" \
		--$(BUILD_MODE) \
		--pull="$(PULL_POLICY)" \
		--no-cache="$(NO_CACHE)" \
		--tag "$(IMAGE_NAME):$(IMAGE_TAG)" \
		-f Containerfile \
			"$(SRC_DIR)"

.PHONY: build
build: image
	mkdir -p "$(BUILD_DIR)"
	podman run \
		-it --rm \
		-v "$(BUILD_DIR):/out" \
			"$(IMAGE_NAME):$(IMAGE_TAG)"
	echo "install with \`dpkg -i /tmp/build-freetube/out/*.deb\`"

.PHONY: install
install: build
	sudo dpkg -i /tmp/build-freetube/out/*.deb \
		&& rm -rf /tmp/build-freetube
	$(MAKE) clean

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
