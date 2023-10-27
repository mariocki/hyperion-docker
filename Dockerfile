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

ADD https://api.github.com/repos/SDL-Hercules-390/gists/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/gists.git
ADD https://api.github.com/repos/SDL-Hercules-390/hyperion/git/refs/heads/master version.json
RUN git clone --depth 1 https://github.com/SDL-Hercules-390/hyperion.git

WORKDIR /build/gists

RUN ./extpkgs.sh clone c d s t

WORKDIR /build/hyperion

RUN ./configure --enable-extpkgs=/build/gists

RUN make

RUN mkdir -p /build/hyperion-docker

RUN make install DESTDIR=/build/hyperion-docker

WORKDIR /build/

RUN mkdir -p hyperion-docker/DEBIAN

RUN echo "Package: hyperion-docker" >> hyperion-docker/DEBIAN/control

RUN echo "Version: 1.0" >> hyperion-docker/DEBIAN/control

RUN echo $'Section: base\n\
Priority: optional\n\
Architecture: amd64\n\
Depends: libbz2-1.0, libzip4\n\
Maintainer: Your Name <you@email.com>\n\
Description: Hyperion\n\
 OS360 emulator from https://github.com/SDL-Hercules-390' >> hyperion-docker/DEBIAN/control

RUN dpkg-deb --build hyperion-docker

FROM debian:sid-slim as hyperion

COPY --from=build-stage /build/hyperion-docker.deb /hyperion-docker.deb

RUN apt-get update && apt-get -y upgrade && apt-get install -y libzip4 procps

RUN mkdir -p /tk4 && \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/usrlocal

RUN dpkg -i /hyperion-docker.deb

RUN ldconfig

WORKDIR /tk4

CMD ./mvs
