# syntax = docker/dockerfile:1.3-labs
FROM debian:sid-slim as build-stage

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  apt-transport-https \
  ca-certificates \
  curl \
  git-core \
  cmake \
  time \
  flex \
  gawk \
  m4 \
  autoconf \
  automake \
  libtool \
  libltdl-dev \
  libbz2-dev \
  zlib1g-dev \
  libcap2-bin \
  libregina3-dev

WORKDIR /build

RUN git clone https://github.com/SDL-Hercules-390/gists.git

WORKDIR /build/gists

RUN ./extpkgs.sh clone c d s t

WORKDIR /build

RUN git clone https://github.com/SDL-Hercules-390/hyperion.git

WORKDIR /build/hyperion

RUN ./configure --enable-extpkgs=/build/gists

RUN make

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

FROM debian:sid-slim

RUN apt-get update && apt-get install -y --no-install-recommends screen procps vim sudo wget gnupg2 apt-transport-https ca-certificates curl 

COPY --from=build-stage /build/hyperion-docker_1.0-1.deb /

RUN dpkg -i /hyperion-docker_1.0-1.deb

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/hercules

RUN <<EOF cat >> /run.sh
#!/bin/sh
ldconfig
cd /tk4
./mvs
EOF

RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
CMD []  
