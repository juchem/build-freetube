.PHONY: all image build interactive

all: image

image:
	DOCKER_BUILDKIT=1 \
		docker build \
			-t build-freetube \
				docker

build: image
	mkdir -p out \
		&& docker run -it --rm \
			-v "`pwd`/out:/out" \
				build-freetube

interactive: image
	mkdir -p out \
		&& docker run -it --rm \
			-v "`pwd`/out:/out" \
			--entrypoint bash \
				build-freetube
