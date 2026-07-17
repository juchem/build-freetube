#!/bin/bash -xe

build_freetube() {
  pushd "${FREETUBE_SRC}" > /dev/null

  build_version="${FREETUBE_VERSION:-master}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive --depth=1

  sed -i \
    -e "s|Platform.LINUX.createTarget(\[[^]]*\]|Platform.LINUX.createTarget(['deb']|g" \
    "${FREETUBE_SRC}/_scripts/build.mjs"

  # https://github.com/FreeTubeApp/FreeTube/blob/development/.github/workflows/build.yml
  mkdir -p "${FREETUBE_SRC}/build"
  pushd "${FREETUBE_SRC}/build" > /dev/null
  (set -x; \
    time pnpm install \
    && time pnpm run build
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
