FROM public.ecr.aws/docker/library/alpine:3.22.1

WORKDIR /root
COPY . dotfiles/

ENV TERM=xterm-256color
WORKDIR /root/dotfiles

# Install base dependencies
RUN apk --no-cache add bash curl git build-base linux-headers

SHELL ["/bin/bash", "-c"]

# Deploy dotfiles and install devbox
RUN source ./install.sh && deploy_dotfiles
RUN TMPDIR=/tmp source ./install.sh && install_devbox

# Setup devbox environment with disk space optimization  
RUN mkdir -p /tmp/nix && \
  TMPDIR=/tmp/nix devbox global shellenv > /tmp/devbox_env && \
  echo 'source /tmp/devbox_env' >> /root/.bashrc

# Refresh environment and install core tools
RUN eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r
RUN devbox global add gcc neovim zsh

# Install and setup Rust
RUN devbox global add rustup && \
  eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r
RUN eval "$(devbox global shellenv)" && \
  export CC="$(which gcc)" && export CXX="$(which g++)" && \
  rustup default stable

# Install additional tools
RUN source ./install.sh && install_languages
RUN eval "$(devbox global shellenv)" && cargo install pueue

# Setup Neovim
RUN eval "$(devbox global shellenv)" && nvim --headless "+Lazy! sync" +qa || true

# Setup Zsh
RUN eval "$(devbox global shellenv)" && zsh -c "source ~/.zshrc" || true

# Clean up to reduce image size
# RUN rm -rf /nix/store/.links /nix/var/nix/gcroots/auto/* /nix/var/nix/db/db.sqlite-* || true

CMD ["/bin/bash"]
