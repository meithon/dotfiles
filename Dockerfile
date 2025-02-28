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
  build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  speedtest-cli \
  hping3 \
  fping \
  ethtool \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY . dotfiles/


ENV TERM=xterm-256color
WORKDIR /root/dotfiles
# RUN ./install.sh -y

SHELL ["/bin/bash", "-c"]

RUN ./install/deploy_dotfiles.sh
RUN ./install/install_tools.sh
RUN . ~/dotfiles/shell/asdf.sh && ./install/setup_asdf.sh
RUN . ~/dotfiles/shell/asdf.sh && ./install/setup_rust.sh
# RUN nvim --headless "+Lazy! sync" "+lua print('Lazy sync completed')" +qa

CMD ["/bin/bash"]
