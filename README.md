A self-contained, sandboxed container image that will build and install
[freetube](https://freetubeapp.io/).

**TL;DR**: build and install latest version under `/usr/local`:
```
# build the builder image:
make

# build latest `freetube` using the builder image:
docker run -it --rm \
  -v /usr/local:/out \
    build-freetube
```

Choose the version to build by setting environment variables (defaults to
`HEAD` for bleeding edge):
- [`FREETUBE_VERSION`](https://freetubeapp.io/releases)

Binaries will be installed into the container's directory `/out`. Mount that
directory with `-v host_dir:/out` to install it into some host directory.

Customize the base installation directory by setting the environment variable
`PREFIX_DIR`. Defaults to `/usr/local`.

Example: install specific version `~/opt` with:
```
OUT_DIR="$HOME/opt"
mkdir -p "${OUT_DIR}"
# build freetube using the build image
docker run -it --rm \
  -v "${OUT_DIR}:/out" \
  -e "FREETUBE_VERSION=v1.2.3" \
    build-freetube
```
