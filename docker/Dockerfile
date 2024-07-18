FROM debian:testing-slim

#################
# base settings #
#################

ENV DEBIAN_PRIORITY=critical
ENV DEBIAN_FRONTEND=noninteractive

RUN truncate --size=0 /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d
RUN mkdir -p /etc/apt/sources.list.d
COPY debian-testing.list /etc/apt/sources.list.d/
COPY debian-unstable.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
  ca-certificates \
  file cpio coreutils time \
  curl wget git \
  gzip bzip2 xz-utils

# freetube repo: https://github.com/FreeTubeApp/FreeTube.git

ENV FREETUBE_SRC="/src/freetube"

RUN mkdir -p "${FREETUBE_SRC}"
RUN cd "${FREETUBE_SRC}" \
  && git init \
  && git remote add origin "https://github.com/FreeTubeApp/FreeTube.git"

# freetube build deps
# - https://github.com/FreeTubeApp/FreeTube/blob/development/.github/workflows/build.yml

RUN apt-get install -y --no-install-recommends \
  nodejs npm yarnpkg \
  build-essential \
  binutils \
  dpkg-dev \
  libarchive-tools


RUN apt-get install -y --no-install-recommends \
  rpm

# finish

RUN apt-get update && apt-get upgrade -y
RUN apt autoremove --purge -y
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

WORKDIR "/src"
RUN mkdir -p /out

ENV PREFIX_DIR="/usr/local"

COPY entrypoint.sh /srv
ENTRYPOINT "/srv/entrypoint.sh"
