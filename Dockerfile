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

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
  apt-transport-https \
  bash \
  ca-certificates \
  curl \
  gnupg2 \
  htop \
  net-tools \
  openvpn \
  procps \
  screen \
  sudo \
  vim \
  wget 

COPY --from=build-stage /build/hyperion-docker_1.0-1.deb /

RUN dpkg -i /hyperion-docker_1.0-1.deb

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/hercules

# enable ipv4 forwarding
RUN sed 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

RUN <<EOF cat >> /run.sh
#!/bin/bash
ldconfig
[[ ! -c /dev/net/tun ]] && { echo "creating tun"; mkdir -p /dev/net; mknod /dev/net/tun c 10 200; chmod +rw /dev/net/tun; }
openvpn --mktun --dev tun
cd /tk4
cat /dev/null > prt/prt002.txt
cat /dev/null > prt/prt00e.txt
cat /dev/null > prt/prt00f.txt
./mvs
EOF

RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
CMD []  

EXPOSE 3270 8038 21000
