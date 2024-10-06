FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  iputils-ping \
  traceroute \
  nmap \
  netcat \
  tcpdump \
  tshark \
  curl \
  wget \
  telnet \
  dnsutils \
  whois \
  net-tools \
  iftop \
  iptraf \
  mtr \
  ngrep \
  iperf3 \
  iproute2 \
  htop \
  nload \
  speedtest-cli \
  hping3 \
  fping \
  ethtool \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . .


ENV TERM=xterm-256color
RUN ./install.sh

CMD ["/bin/bash"]
