.PHONY: all image build build-from-scratch image-from-scratch interactive help

all: build

image:
	podman build \
		-t build-freetube \
		-f Containerfile \
			container

image-from-scratch:
	podman build \
		--no-cache \
		-t build-freetube \
		-f Containerfile \
			container

build: image
	mkdir -p /tmp/build-freetube/out
	podman run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
			build-freetube
	echo "install with \`dpkg -i /tmp/build-freetube/out/*.deb\`"

build-from-scratch: image-from-scratch
	mkdir -p /tmp/build-freetube/out
	podman run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
			build-freetube
	echo "install with \`dpkg -i /tmp/build-freetube/out/*.deb\`"

install: build
	sudo dpkg -i /tmp/build-freetube/out/*.deb \
		&& rm -rf /tmp/build-freetube

install-from-scratch: build-from-scratch
	sudo dpkg -i /tmp/build-freetube/out/*.deb \
		&& rm -rf /tmp/build-freetube

interactive: image
	mkdir -p /tmp/build-freetube/out
	podman run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
		--entrypoint bash \
			build-freetube

help:
	@grep '^[a-zA-Z\-_0-9].*:' Makefile | cut -d : -f 1 | sort
