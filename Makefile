.PHONY: all image build interactive

all: build

image:
	DOCKER_BUILDKIT=1 \
		docker build \
			-t build-freetube \
				docker

build: image
	mkdir -p out \
		&& docker run -it --rm \
			-v "/tmp/build-freetube/out:/out" \
				build-freetube

interactive: image
	mkdir -p out \
		&& docker run -it --rm \
			-v "/tmp/build-freetube/out:/out" \
			--entrypoint bash \
				build-freetube

help:
	grep '^[a-zA-Z\-_0-9].*:' Makefile | cut -d : -f 1 | sort
