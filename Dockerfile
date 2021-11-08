# syntax = docker/dockerfile:1.3-labs
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

ADD https://api.github.com/repos/SDL-Hercules-390/gists/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/gists.git
ADD https://api.github.com/repos/SDL-Hercules-390/hyperion/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/hyperion.git

WORKDIR /build/gists

RUN ./extpkgs.sh clone c d s t

WORKDIR /build/hyperion

RUN ./configure --enable-extpkgs=/build/gists

RUN make -j 2

RUN mkdir -p /build/hyperion-docker_1.0-1

RUN make install DESTDIR=/build/hyperion-docker_1.0-1

WORKDIR /build/

RUN mkdir -p hyperion-docker_1.0-1/DEBIAN

RUN <<EOF cat >> hyperion-docker_1.0-1/DEBIAN/control
Package: hyperion-docker
Version: 1.0-1
Section: base
Priority: optional
Architecture: amd64
Depends: 
Maintainer: Your Name <you@email.com>
Description: Hyperion
 OS360 emulator from https://github.com/SDL-Hercules-390
EOF

RUN dpkg-deb --build hyperion-docker_1.0-1
