#!/bin/bash -xe

build_freetube() {
  pushd "${FREETUBE_SRC}" > /dev/null

  build_version="${FREETUBE_VERSION:-HEAD}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive --depth=1

  # https://github.com/FreeTubeApp/FreeTube/blob/development/.github/workflows/build.yml
  mkdir -p "${FREETUBE_SRC}/build"
  pushd "${FREETUBE_SRC}/build" > /dev/null
  (set -x; \
    time yarnpkg install \
    && time yarnpkg run build
  )
  mv /src/freetube/build/freetube_*.deb /out
  popd > /dev/null

  popd > /dev/null
}

(set -x; apt-get update)
(set -x; apt-get upgrade -y --only-upgrade --no-install-recommends)

(set -x; build_freetube "$@")

cat <<EOF

Successfully built freetube.
EOF
