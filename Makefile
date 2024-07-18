.PHONY: all image build build-from-scratch image-from-scratch interactive help

all: build

image:
	docker build \
		-t build-freetube \
			docker

image-from-scratch:
	docker build \
		-t build-freetube \
		--no-cache \
			docker

build: image
	docker run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
			build-freetube

build-from-scratch: image-from-scratch
	docker run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
			build-freetube

interactive: image
	docker run \
		-it --rm \
		-v "/tmp/build-freetube/out:/out" \
		--entrypoint bash \
			build-freetube

help:
	@grep '^[a-zA-Z\-_0-9].*:' Makefile | cut -d : -f 1 | sort
