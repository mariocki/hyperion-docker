# syntax = docker/dockerfile:1.4.0

FROM debian:sid-slim as build-stage

RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-transport-https \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  cmake \
  curl \
  flex \
  gawk \
  git-core \
  libbz2-dev \
  libcap2-bin \
  libltdl-dev \
  libregina3-dev \
  libtool \
  m4 \
  time \
  wget \
  zlib1g-dev

WORKDIR /build

ARG LAST_SERVER_COMMIT

ADD https://api.github.com/repos/SDL-Hercules-390/gists/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/gists.git
ADD https://api.github.com/repos/SDL-Hercules-390/hyperion/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/hyperion.git

WORKDIR /build/gists

RUN ./extpkgs.sh clone c d s t

WORKDIR /build/hyperion

RUN git describe --tags | cut -d '_' -f2 > /tmp/version.txt

RUN ./configure --enable-extpkgs=/build/gists

RUN make -j

RUN mkdir -p /build/hyperion-docker_`cat /tmp/version.txt`

RUN make install DESTDIR=/build/hyperion-docker_`cat /tmp/version.txt`

WORKDIR /build/

RUN mkdir -p hyperion-docker_`cat /tmp/version.txt`/DEBIAN

RUN echo "Package: hyperion-docker" >> hyperion-docker_`cat /tmp/version.txt`/DEBIAN/control

RUN echo "Version: `cat /tmp/version.txt`" >> hyperion-docker_`cat /tmp/version.txt`/DEBIAN/control

RUN echo $'Section: base\n\
Priority: optional\n\
Architecture: amd64\n\
Depends: libbz2-1.0, libzip4\n\
Maintainer: Your Name <you@email.com>\n\
Description: Hyperion\n\
 OS360 emulator from https://github.com/SDL-Hercules-390' >> hyperion-docker_`cat /tmp/version.txt`/DEBIAN/control

RUN dpkg-deb --build hyperion-docker_`cat /tmp/version.txt`

RUN mv hyperion-docker_`cat /tmp/version.txt`.deb /
