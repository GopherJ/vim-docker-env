FROM ubuntu:22.04
LABEL Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96
ARG GO_VERSION=1.19.3
ARG NODE_VERSION=v18
ARG RUST_TOOLCHAIN=nightly-2023-05-02
ARG TABNINE_VERSION=4.4.225
ARG RUST_ANALYZER_VERSION=2023-01-21
ARG SOLC_VERSION=0.8.10

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

RUN apt update --fix-missing \
  && apt upgrade -y \
  && apt install -y \
  gcc-riscv64-linux-gnu \
  nvidia-cuda-toolkit \
  toilet \
  figlet \
  git-lfs \
  flameshot \
  inkscape \
  gimp \
  kazam \
  pandoc \
  dnsutils \
  alsa-utils \
  transmission \
  ffmpeg \
  tig \
  wabt \
  proxychains4 \
  wireshark \
  duf \
  aria2 \
  tzdata \
  libssl-dev \
  librsvg2-bin \
  z3 \
  libz3-dev \
  postgresql-client \
  mysql-client \
  expat \
  qrencode \
  git \
  lld \
  wget \
  curl \
  xclip \
  cmake \
  jupyter \
  jupyter-core \
  gh \
  latexmk \
  texstudio \
  texlive \
  texinfo \
  texlive-fonts-recommended \
  texlive-fonts-extra \
  texlive-latex-extra \
  texlive-bibtex-extra \
  texlive-xetex \
  bear \
  apt-utils \
  apt-rdepends \
  nmap \
  build-essential \
  gfortran \
  mosh \
  certbot \
  mingw-w64 \
  libncurses5-dev \
  libncursesw5-dev \
  debhelper \
  inotify-tools \
  watchman \
  p7zip-full \
  ansible \
  ssh \
  htop \
  sshpass \
  xz-utils \
  gawk \
  unzip \
  git-extras \
  libclang-dev \
  llvm \
  zlib1g-dev \
  libmpc-dev \
  libmpfr-dev \
  libgmp-dev \
  libxml2-dev \
  libasound2-dev \
  libboost-all-dev \
  libarmadillo-dev \
  libjsoncpp-dev \
  libblas-dev \
  libopenblas-dev \
  liblapack-dev \
  libfreetype6-dev \
  libexpat1-dev \
  libfontconfig1-dev \
  libxcb-composite0-dev \
  libharfbuzz-dev \
  libxcb-xfixes0-dev \
  libxkbcommon-dev \
  libutempter-dev \
  libpq-dev \
  libpqxx-dev \
  libmysqlclient-dev \
  libjansson-dev \
  libsodium-dev \
  libgrpc++-dev \
  libbenchmark-dev \
  libomp-dev \
  uuid-dev \
  libprotobuf-dev \
  nlohmann-json3-dev \
  libsecp256k1-dev \
  sudo \
  ninja-build \
  gfortran \
  parallel \
  musl-tools \
  xdotool \
  autoconf \
  python3-autopep8 \
  automake \
  libtool \
  tmux \
  clang-format \
  cppcheck \
  ruby \
  ruby-dev \
  python3 \
  python3-pip \
  apt-file \
  openssh-client \
  openssh-server \
  jq \
  ripgrep \
  ranger \
  zsh \
  apt-transport-https \
  openjdk-8-jdk \
  openjdk-11-jdk \
  openjdk-17-jdk \
  protobuf-compiler \
  software-properties-common \
  ca-certificates \
  gnupg \
  gnupg2 \
  pkg-config \
  imagemagick \
  bash-completion \
  clangd-15 \
  clang-15 \
  nasm \
  protobuf-compiler \
  protobuf-compiler-grpc \
  binaryen \
  sagemath \
  pari-gp \
  && update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100 \
  && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 1 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-15 \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd ${APP_USER} --user-group --create-home --shell /usr/bin/zsh --groups sudo \
  && yes ${APP_USER} | passwd ${APP_USER}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && sed -i 's/required/sufficient/1' /etc/pam.d/chsh

RUN ( \
  echo 'Port 9999'; \
  echo 'ChallengeResponseAuthentication no'; \
  echo 'UsePAM yes'; \
  echo 'X11Forwarding yes'; \
  echo 'PrintMotd no'; \
  echo 'AcceptEnv LANG LC_*'; \
  echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  echo 'PasswordAuthentication yes'; \
  echo 'MaxAuthTries 30'; \
  ) > /etc/ssh/sshd_config \
  && mkdir /run/sshd

USER ${APP_USER}
WORKDIR /home/${APP_USER}
RUN mkdir -p /home/${APP_USER}/src

RUN git clone https://github.com/universal-ctags/ctags ~/ctags \
  && cd ~/ctags \
  && ./autogen.sh \
  && ./configure \
  && make \
  && sudo make install

RUN wget https://github.com/chevdor/subwasm/releases/download/v0.18.0/subwasm_linux_amd64_v0.18.0.deb -O subwasm.deb \
  && sudo dpkg -i subwasm.deb

RUN wget https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz \
  && tar -xJf upx-3.94-amd64_linux.tar.xz \
  && chmod u+x upx-3.94-amd64_linux/upx \
  && sudo mv upx-3.94-amd64_linux/upx /usr/local/bin

RUN curl -fsSL https://code-server.dev/install.sh | sh

# RUN wget https://github.com/hyperledger-labs/solang/releases/download/v0.2.0/solang-linux-x86-64 \
#   && chmod u+x solang-linux-x86-64  \
#   && sudo mv solang-linux-x86-64 /usr/local/bin

# RUN pip3 install --upgrade solc-select \
#   && solc-select install ${SOLC_VERSION} \
#   && solc-select use ${SOLC_VERSION}

# RUN wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
#     && tar -xzvf cmake-3.18.4.tar.gz \
#     && cd cmake-3.18.4 \
#     && ./bootstrap \
#     && make -j4 \
#     && sudo make install

# RUN curl -fLo ~/ripgrep_12.1.1_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb --retry-delay 2 --retry 3 \
#     && sudo dpkg -i ~/ripgrep_12.1.1_amd64.deb

ENV GOENV_ROOT=/home/${APP_USER}/.goenv
ENV NVM_DIR=/home/${APP_USER}/.nvm
ENV CARGO_HOME=/home/${APP_USER}/.cargo
ENV USER=${APP_USER}
ENV VCPKG_ROOT=/home/${APP_USER}/vcpkg

ENV PATH=$CARGO_HOME/bin:$NVM_DIR/versions/node/${NODE_VERSION}/bin:$GOENV_ROOT/bin:$GOENV_ROOT/versions/$GO_VERSION/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${APP_USER}/.local/bin:/home/${APP_USER}/osxcross/target/bin

# RUN git clone https://github.com/Microsoft/vcpkg.git \
#   && cd vcpkg \
#   && ./bootstrap-vcpkg.sh \
#   && sudo ln -s $(pwd)/vcpkg /usr/local/bin

# RUN git clone https://github.com/tpoechtrager/osxcross \
#   && cd osxcross \
#   && wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz \
#   && mv MacOSX10.10.sdk.tar.xz tarballs \
#   && UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

RUN git clone https://github.com/syndbg/goenv.git ~/.goenv \
  && eval "$(goenv init -)" \
  && goenv install $GO_VERSION \
  && goenv global $GO_VERSION \
  && goenv rehash \
  && go install github.com/go-delve/delve/cmd/dlv@latest \
  && go install github.com/golang/protobuf/protoc-gen-go@latest \
  && go install github.com/mgechev/revive@latest \
  && go install github.com/charmbracelet/glow@latest \
  && go install github.com/Dreamacro/clash@latest \
  && go install github.com/wealdtech/ethdo@latest \
  && go install github.com/boyter/scc/v3@latest \
  && go install github.com/jfeliu007/goplantuml/cmd/goplantuml@latest

RUN git clone https://github.com/ethereum/go-ethereum \
  && cd go-ethereum \
  && make all \
  && sudo cp \
  ./build/bin/abigen \
  ./build/bin/clef \
  ./build/bin/geth \
  ./build/bin/evm \
  ./build/bin/rlpdump \
  /usr/local/bin/

# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
#   && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
#   && sudo apt update -y \
#   && sudo apt -y install google-cloud-sdk

# RUN curl -O https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
#   && unzip awscli-exe-linux-x86_64.zip \
#   && cd aws \
#   && sudo ./install

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && sudo apt update -y \
  && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y \
  && sudo usermod -aG docker ${APP_USER}

RUN sudo add-apt-repository ppa:hluk/copyq \
  && sudo apt update \
  && sudo apt install copyq

RUN sudo add-apt-repository ppa:maveonair/helix-editor \
  && sudo apt update \
  && sudo apt install helix

RUN curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm@0.39.3/install.sh | bash \
  && curl -fsSL https://fnm.vercel.app/install | bash \
  && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" \
  && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node" \
  && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm" \
  && nvm install $NODE_VERSION \
  && nvm use $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm install-latest-npm \
  && npm install -g yarn instant-markdown-d \
  && yarn global add \
  zksync-cli \
  gulp-cli \
  sol2uml \
  tx2uml \
  doctoc \
  ts-node \
  markdownlint \
  ipfs \
  @marp-team/marp-cli \
  @vue/cli \
  create-react-app \
  create-near-app \
  vls \
  typescript \
  eslint \
  eslint-plugin-vue \
  prettier \
  neovim \
  near-cli \
  assemblyscript \
  browserify \
  @polkadot/api-cli \
  @open-web3/parachain-launch \
  @subql/cli \
  graphviz \
  graphql-language-service-cli \
  solidity-shell \
  ganache \
  snarkjs \
  snarkit2

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
  sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN} --component rust-src --target wasm32-unknown-unknown --target wasm32-wasi --target x86_64-pc-windows-gnu --target x86_64-apple-darwin \
  && . /home/${APP_USER}/.cargo/env \
  && curl -fLo ~/.cargo/config --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/cargo/config \
  && cargo install cargo-edit \
  && cargo install wasm-tools \
  && cargo install sccache \
  && cargo install just \
  && cargo install git-interactive-rebase-tool \
  && cargo install --git https://github.com/facebook/buck2 buck2 \
  && cargo install cargo-whatfeatures --no-default-features --features "rustls" \
  && rustup install nightly-2023-04-23 && cargo +nightly-2023-04-23 install --git https://github.com/facebook/buck2.git buck2 \
  && cargo install --features cli etk-asm etk-dasm \
  && cargo install --git https://github.com/ClementTsang/bottom \
  && cargo install --git https://github.com/svenstaro/miniserve \
  && cargo install svm-rs \
  && cargo install texlab \
  && cargo install ethabi \
  && cargo install tidy-viewer \
  && cargo install shadowsocks-rust \
  && cargo install typos-cli \
  && cargo install cargo-bump \
  && cargo install tokei \
  && cargo install xh \
  && cargo install dprint \
  && cargo install onefetch \
  && cargo install git-brws \
  && cargo install hyperfine \
  && cargo install cargo-update \
  && cargo install cargo-chef \
  && cargo install watchexec-cli \
  && cargo install cargo-deadlinks \
  && cargo install cargo-generate-rpm\
  && cargo install cargo-deb \
  && cargo install --locked cargo-outdated \
  && cargo install exa \
  && cargo install cross \
  && cargo install zoxide \
  && cargo install --git https://github.com/iden3/circom --bin circom \
  && cargo install --git https://github.com/fluidex/plonkit --bin plonkit \
  && (cargo install --git https://github.com/ogham/dog --features=with_tls --features=with_https -- --package dog || true) \
  && cargo install circomspect \
  && cargo install du-dust \
  && cargo install silicon \
  && cargo install cargo-generate \
  && cargo install basic-http-server \
  && cargo install bat \
  && cargo install mdbook \
  mdbook-mermaid \
  mdbook-linkcheck \
  mdbook-plantuml \
  mdbook-graphviz \
  mdbook-toc \
  && cargo install --git https://github.com/lzanini/mdbook-katex \
  && cargo install diesel_cli --no-default-features --features postgres \
  && cargo install --force --git https://github.com/google/evcxr.git evcxr_repl \
  && cargo install --force --git https://github.com/paritytech/cargo-remote \
  && cargo install --git https://gitlab.com/chevdor/srtool-cli \
  && cargo install --git https://github.com/alacritty/alacritty \
  && curl -L https://foundry.paradigm.xyz | bash \
  && ~/.foundry/bin/foundryup \
  && curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/alacritty/alacritty.yml --retry-delay 2 --retry 3 \
  && cargo install --git https://github.com/extrawurst/gitui \
  && curl -fo ~/.config/gitui/key_config.ron --create-dirs https://cdn.jsdelivr.net/gh/extrawurst/gitui/vim_style_key_config.ron \
  && cargo install --git https://github.com/sharkdp/fd \
  && git clone https://github.com/rust-analyzer/rust-analyzer.git \
  && cargo install --git https://github.com/paritytech/cargo-contract cargo-contract --features extrinsics --force \
  && cargo install --git https://github.com/dtolnay/cargo-expand \
  && cargo install --git https://github.com/vi/websocat --features=ssl \
  && cd rust-analyzer \
  && git checkout $RUST_ANALYZER_VERSION \
  && cargo xtask install --server \
  && curl https://getsubstrate.io -sSf | bash -s \
  && cargo install --force subkey --git https://github.com/paritytech/substrate --branch polkadot-v0.9.36 \
  && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh


RUN sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh/tools/install.sh)" \
  && curl https://cdn.jsdelivr.net/gh/GopherJ/cfg/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN curl -fsSL https://sh.iroh.computer/install_laptop.sh | sh

RUN sudo add-apt-repository ppa:jonathonf/vim \
  && sudo add-apt-repository ppa:neovim-ppa/unstable \
  && sudo add-apt-repository ppa:ethereum/ethereum \
  && sudo apt update -y \
  && sudo apt install -y vim neovim solc ethereum \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade solc-select \
  && pip3 install --user jupyter \
  && pip3 install --user you-get \
  && pip3 install --user codespell \
  && pip3 install --user detect-secrets \
  && pip3 install --user wheel \
  && pip3 install --user panoramix-decompiler \
  && pip3 install --user cmake-format \
  && pip3 install --user -U jedi \
  && pip3 install --user pynvim \
  && pip3 install --user awscli \
  && pip3 install --user maturin \
  && curl -sSL https://install.python-poetry.org | python3 - \
  && sudo gem install neovim \
  && curl -fo ~/.vimrc https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/.vimrc --retry-delay 2 --retry 3 \
  && curl -fo ~/.vim/coc-settings.json --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/coc-settings.json --retry-delay 2 --retry 3 \
  && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://cdn.jsdelivr.net/gh/junegunn/vim-plug/plug.vim --retry-delay 2 --retry 3 \
  && if [ ! -d ~/.config ]; then mkdir ~/.config; fi \
  && ln -s ~/.vim ~/.config/nvim \
  && ln -s ~/.vimrc ~/.config/nvim/init.vim \
  && nvim --headless +PlugInstall +qall \
  && nvim --headless +VimspectorInstall +qall \
  && curl -fo ~/.vimspector.json --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/vimspector/.vimspector.json --retry-delay 2 --retry 3 \
  && if [ ! -d ~/.config/coc/extensions ]; then mkdir -p ~/.config/coc/extensions; fi \
  && curl -fo ~/.config/coc/extensions/package.json https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/package.json --retry-delay 2 --retry 3 \
  && cd ~/.config/coc/extensions \
  && npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod \
  && curl -fo ~/.vim/tasks.ini https://cdn.jsdelivr.net/gh/GopherJ/cfg/asynctasks/tasks.ini --retry-delay 2 --retry 3 \
  && curl -fo --create-dirs ~/.config/coc/ultisnips/vim.snippets https://cdn.jsdelivr.net/gh/GopherJ/cfg/snippets/vim.snippets --retry-delay 2 --retry 3

RUN solc-select install ${SOLC_VERSION} \
  && solc-select use ${SOLC_VERSION}

RUN curl -fLo ~/.config/coc/extensions/coc-tabnine-data/binaries/$TABNINE_VERSION/TabNine.zip --create-dirs https://update.tabnine.com/bundles/$TABNINE_VERSION/$(uname -m)-unknown-linux-musl/TabNine.zip \
  && cd ~/.config/coc/extensions/coc-tabnine-data/binaries \
  && echo "$TABNINE_VERSION" > .active \
  && if [ ! -d "$TABNINE_VERSION/$(uname -m)-unknown-linux-musl" ]; then mkdir "$TABNINE_VERSION/$(uname -m)-unknown-linux-musl"; fi \
  && unzip $TABNINE_VERSION/TabNine.zip -d "$TABNINE_VERSION/$(uname -m)-unknown-linux-musl" \
  && cd "$TABNINE_VERSION/$(uname -m)-unknown-linux-musl" \
  && chmod u+x ./TabNine ./TabNine-deep-cloud ./TabNine-deep-local ./WD-TabNine

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && curl -fLo ~/.tmux.conf --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/tmux/.tmux.conf --retry-delay 2 --retry 3 \
  && curl -fLo ~/.tmuxline_snapshot --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/tmux/.tmuxline_snapshot --retry-delay 2 --retry 3

RUN git clone https://github.com/GopherJ/cfg ~/cfg \
  && cd ~/cfg/fonts \
  && ./install-fira-code.sh

RUN curl -fsSL https://cdn.jsdelivr.net/gh/filebrowser/get/get.sh | bash

RUN sudo apt install locales && sudo locale-gen en_US.UTF-8

RUN rm /home/${APP_USER}/*.deb \
  && rm -fr /home/${APP_USER}/*.tar.xz \
  && rm -fr /home/${APP_USER}/*.tar.gz \
  && rm -fr /home/${APP_USER}/*.zip \
  && rm -fr /home/${APP_USER}/rust-analyzer \
  && rm -fr /home/${APP_USER}/upx-3.94-amd64_linux \
  && rm -fr /home/${APP_USER}/ctags \
  && rm -fr /home/${APP_USER}/.cargo/registry

WORKDIR /home/${APP_USER}/src

EXPOSE 9999

CMD ["sudo", "/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
