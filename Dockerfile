FROM ubuntu:22.04
LABEL Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96
ARG GO_VERSION=1.22.3
ARG NODE_VERSION=v18
ARG RUST_TOOLCHAIN=nightly-2024-05-06
ARG TABNINE_VERSION=4.4.225
ARG RUST_ANALYZER_VERSION=2023-01-21
ARG SOLC_VERSION=0.8.21
ARG PY_VERSION=3.10.0

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

RUN apt update --fix-missing \
  && apt upgrade -y \
  && apt install -y \
  libsecret-1-0 \
  libsecret-1-dev \
  linux-tools-common \
  linux-tools-generic \
  linux-tools-`uname -r` \
  tesseract-ocr \
  bpfcc-tools \
  screenkey \
  wine64 \
  gdb-multiarch \
  binutils-riscv64-linux-gnu \
  binutils-common \
  linux-headers-$(uname -r) \
  gcc-riscv64-linux-gnu \
  g++-riscv64-linux-gnu \
  gcc-riscv64-unknown-elf \
  gcc-arm-linux-gnueabihf \
  gcc-aarch64-linux-gnu \
  nvidia-cuda-toolkit \
  bsdmainutils \
  xvfb \
  tor \
  x11-apps \
  x11-xkb-utils \
  libx11-6 \
  libx11-xcb1 \
  toilet \
  figlet \
  rofi \
  nnn \
  sshfs \
  qemu-user \
  qemu-user-static \
  qemu-system-riscv32 \
  virtualbox \
  virtualbox-dkms \
  virtualbox-ext-pack \
  virtualbox-guest-additions-iso \
  virtualbox-guest-utils \
  virtualbox-qt \
  neomutt \
  mold \
  lld \
  git-lfs \
  flameshot \
  inkscape \
  gimp \
  kazam \
  calibre \
  pandoc \
  dnsutils \
  alsa-utils \
  transmission \
  ffmpeg \
  bindgen \
  tig \
  wabt \
  proxychains4 \
  wireshark \
  duf \
  aria2 \
  tzdata \
  libc-dev \
  libc6-dev-i386 \
  lld-15 \
  libcxxopts-dev \
  libstdc++-12-dev \
  librsvg2-bin \
  z3 \
  postgresql-client \
  redis-tools \
  mysql-client \
  expat \
  qrencode \
  git \
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
  texmaker \
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
  bison \
  flex \
  texinfo \
  gperf \
  valgrind \
  patchutils \
  bc \
  libglib2.0-dev \
  libssl-dev \
  libslirp-dev \
  zlib1g-dev \
  libmpc-dev \
  libmpfr-dev \
  libgmp-dev \
  libxml2-dev \
  libasound2-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libboost-all-dev \
  libarmadillo-dev \
  libjsoncpp-dev \
  libblas-dev \
  libopenblas-dev \
  liblapack-dev \
  libbenchmark-dev \
  libfreetype6-dev \
  libexpat1-dev \
  libfontconfig1-dev \
  libxcb-composite0-dev \
  libharfbuzz-dev \
  libxcb-xfixes0-dev \
  libxkbcommon-dev \
  libutempter-dev \
  liblz4-dev \
  libpq-dev \
  libtbb-dev \
  libpqxx-dev \
  libmysqlclient-dev \
  libjansson-dev \
  libsodium-dev \
  libgrpc++-dev \
  libbenchmark-dev \
  libomp-dev \
  libbz2-dev \
  libreadline-dev \
  librdkafka-dev \
  libev-dev \
  libhiredis-dev \
  libmpdec-dev \
  libevent-dev \
  libsqlite3-dev \
  librocksdb-dev \
  libdb5.3++-dev \
  libz3-dev \
  libzmq3-dev \
  libdb-dev \
  libdb++-dev \
  libminiupnpc-dev \
  uuid-dev \
  libcurl4-openssl-dev \
  libprotobuf-dev \
  nlohmann-json3-dev \
  libsecp256k1-dev \
  sudo \
  ninja-build \
  gfortran \
  parallel \
  musl-tools \
  net-tools \
  xdotool \
  autoconf \
  autotools-dev \
  python3-autopep8 \
  python3.10-venv \
  automake \
  libtool \
  tmux \
  clang-format \
  cppcheck \
  ruby \
  ruby-dev \
  python3 \
  python3-pip \
  conan \
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
  software-properties-common \
  ca-certificates \
  gnupg \
  gnupg2 \
  pkg-config \
  imagemagick \
  bash-completion \
  clangd-15 \
  clang-15 \
  lua5.4 \
  nasm \
  protobuf-compiler \
  protobuf-compiler-grpc \
  binaryen \
  sagemath \
  pari-gp \
  fontforge \
  python3-fontforge \
  && update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100 \
  && update-alternatives --install /usr/bin/llc llc /usr/bin/llc-15 100 \
  && update-alternatives --install /usr/bin/opt opt /usr/bin/opt-15 100 \
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

RUN sudo add-apt-repository ppa:obsproject/obs-studio \
  && sudo apt update \
  && sudo apt install obs-studio -y

RUN wget https://github.com/chevdor/subwasm/releases/download/v0.18.0/subwasm_linux_amd64_v0.18.0.deb -O subwasm.deb \
  && sudo dpkg -i subwasm.deb

RUN wget https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz \
  && tar -xJf upx-3.94-amd64_linux.tar.xz \
  && chmod u+x upx-3.94-amd64_linux/upx \
  && sudo mv upx-3.94-amd64_linux/upx /usr/local/bin

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
  && eval "$(pyenv init -)" \
  && git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv \
  && pyenv install ${PY_VERSION}

RUN git clone https://github.com/emscripten-core/emsdk.git ~/.emsdk \
  && cd ~/.emsdk \
  && ./emsdk install latest \
  && ./emsdk activate latest

RUN curl -L https://sp1.succinct.xyz | bash \
  && [ -s "/home/${APP_USER}/.zshenv" ] && . "/home/${APP_USER}/.zshenv" \
  && sp1up \
  && cargo prove install-toolchain

# RUN wget https://github.com/hyperledger-labs/solang/releases/download/v0.2.0/solang-linux-x86-64 \
#   && chmod u+x solang-linux-x86-64  \
#   && sudo mv solang-linux-x86-64 /usr/local/bin

# RUN pip3 install --upgrade solc-select \
#   && solc-select install ${SOLC_VERSION} \
#   && solc-select use ${SOLC_VERSION}

RUN wget https://cmake.org/files/v3.29/cmake-3.29.3.tar.gz \
  && tar -xzvf cmake-3.29.3.tar.gz \
  && cd cmake-3.29.3 \
  && ./bootstrap \
  && make -j$(nproc) \
  && sudo make install

# RUN curl -fLo ~/ripgrep_12.1.1_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb --retry-delay 2 --retry 3 \
#     && sudo dpkg -i ~/ripgrep_12.1.1_amd64.deb

RUN git clone https://github.com/bitcoin/bitcoin \
  && cd bitcoin \
  && ./autogen.sh \
  && ./configure \
  && make \
  && sudo make install

RUN git clone https://github.com/bitcoin-core/btcdeb \
  && cd btcdeb \
  && ./autogen.sh \
  && ./configure \
  && make \
  && sudo make install

RUN git clone https://github.com/btcsuite/btcd \
  && cd btcd \
  && go install -v . ./cmd/...

RUN wget ttps://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz \
  && tar -zxvf boost_1_76_0.tar.gz \
  && cd boost_1_76_0 \
  && ./bootstrap.sh \
  && ./b2 \
  && sudo ./b2 install

RUN git clone -b version9 https://github.com/libbitcoin/secp256k1 \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-system \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-protocol \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-client \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-server \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-network \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-database \
  && git clone -b version3 https://github.com/libbitcoin/libbitcoin-explorer \
  && cd secp256k1 && ./autogen.sh && ./configure.sh --enable-module-recovery && make && sudo make install && cd .. \
  && cd libbitcoin-system && ./autogen.sh && ./configure.sh && make && sudo make install && cd .. \
  && cd libbitcoin-protocol && ./autogen.sh && ./configure.sh && make && sudo make install && cd .. \
  && cd libbitcoin-network && ./autogen.sh && ./configure.sh && make && sudo make install && cd .. \
  && cd libbitcoin-client && ./autogen.sh && ./configure.sh && make && sudo make install && cd .. \
  && cd libbitcoin-explorer && ./autogen.sh && ./configure.sh && make && sudo make install

ENV GOENV_ROOT=/home/${APP_USER}/.goenv
ENV NVM_DIR=/home/${APP_USER}/.nvm
ENV ZVM_DIR=/home/${APP_USER}/.zvm
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
  && go install golang.org/x/tools/gopls@latest \
  && go install golang.org/x/tools/cmd/goimports@latest \
  && go install github.com/josharian/impl@latest \
  && go install github.com/golang/protobuf/protoc-gen-go@latest \
  && go install github.com/mgechev/revive@latest \
  && go install github.com/charmbracelet/glow@latest \
  && go install github.com/Dreamacro/clash@latest \
  && go install github.com/wealdtech/ethdo@latest \
  && go install github.com/boyter/scc/v3@latest \
  && go install github.com/jfeliu007/goplantuml/cmd/goplantuml@latest \
  && go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest \
  && go install \
  github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
  github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
  google.golang.org/protobuf/cmd/protoc-gen-go \
  google.golang.org/grpc/cmd/protoc-gen-go-grpc

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

# RUN curl -L https://github.com/marler8997/zigup/releases/download/v2024_05_05/zigup-x86_64-linux.tar.gz | tar xz
RUN curl https://cdn.jsdelivr.net/gh/tristanisham/zvm@0.7.1/install.sh | bash \
  && ${ZVM_DIR}/self/zvm install 0.12.0

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
  @ethereumjs/client \
  tldr \
  zksync-cli \
  gulp-cli \
  aicommits \
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
  @graphprotocol/graph-cli \
  graphviz \
  graphql-language-service-cli \
  solidity-shell \
  ganache \
  snarkjs \
  snarkit2

# RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
  sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN} --component llvm-tools --component rustc-dev --component rust-src --target wasm32-unknown-unknown --target wasm32-wasi --target riscv32i-unknown-none-elf --target x86_64-pc-windows-gnu --target x86_64-apple-darwin \
  && . /home/${APP_USER}/.cargo/env \
  && curl -fLo ~/.cargo/config --create-dirs https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/cargo/config \
  && cargo install cargo-edit \
  && cargo install --git https://github.com/typst/typst --locked typst-cli \
  && cargo install --git https://github.com/nvarner/typst-lsp typst-lsp \
  && cargo install --git https://github.com/Enter-tainer/typstyle \
  && cargo install ast-grep \
  && cargo install spl-token-cli \
  && cargo install cbindgen \
  && cargo install sea-orm-cli \
  && cargo install zellij \
  && cargo install cargo-geiger \
  && cargo install cargo-wizard \
  && cargo install cargo-binstall \
  && cargo binstall cargo-risczero \
  && cargo install wasm-tools \
  && cargo install sccache \
  && cargo install just \
  && cargo install fnm \
  && cargo install broot \
  && cargo install stylua \
  && cargo install samply \
  && cargo install flamegraph \
  && cargo install wasm-bindgen-cli \
  && cargo install cargo-zigbuild \
  && cargo install cargo-xwin \
  && cargo install --locked tokio-console \
  && sudo bash -c "echo 0 > /proc/sys/kernel/kptr_restrict" \
  && sudo sysctl kernel.perf_event_paranoid=-1 \
  && sudo sysctl kernel.perf_event_mlock_kb=2048 \
  && sudo sysctl -w kernel.yama.ptrace_scope=0 \
  && echo 0 | sudo tee /proc/sys/kernel/kptr_restrict \
  # && sudo mkdir -p /usr/share/doc/perf-tip && sudo wget https://cdn.jsdelivr.net/gh/linux/tools/perf/Documentation/tips.txt -- /usr/share/doc/perf-tip/tips.txt \
  && cargo install git-interactive-rebase-tool \
  && RUSTFLAGS="-C link-args=-rdynamic" cargo install --force cargo-stylus \
  && cargo install --git https://github.com/MordechaiHadad/bob.git \
  && cargo install --git https://github.com/0xpolygonmiden/compiler --branch develop midenc \
  && cargo install --git https://github.com/casey/just just \
  && cargo install --git https://github.com/okx/ord  ord --tag 0.14.1.3 \
  && cargo install --git https://github.com/facebook/buck2 buck2 \
  && cargo install --git https://github.com/starkware-libs/cairo.git --tag v1.1.0 cairo-lang-compiler \
  && cargo install --git https://github.com/starkware-libs/cairo.git --tag v1.1.0 cairo-language-server \
  && cargo install --git https://github.com/software-mansion/scarb.git --tag v0.3.0 scarb \
  && cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools \
  && cargo install --git https://github.com/crev-dev/cargo-crev \
  && cargo install cargo-whatfeatures --no-default-features --features "rustls" \
  && rustup install nightly-2023-04-23 && cargo +nightly-2023-04-23 install --git https://github.com/facebook/buck2.git buck2 \
  && cargo install --features cli etk-asm etk-dasm \
  && cargo install systemfd \
  && cargo install cargo-watch \
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
  && cargo install --git https://github.com/est31/cargo-udeps \
  && cargo install --git https://github.com/BrainiumLLC/cargo-mobile \
  && cargo install --git https://github.com/bnjbvr/cargo-machete \
  && cargo install --force cargo-make \
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
  && cargo install --git https://github.com/powdr-labs/powdr --features halo2 powdr-cli \
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
  mdbook-i18n-helpers \
  && cargo install --git https://github.com/lzanini/mdbook-katex \
  && cargo install diesel_cli --no-default-features --features postgres \
  && cargo install --force --git https://github.com/google/evcxr.git evcxr_repl \
  && cargo install --force --git https://github.com/paritytech/cargo-remote \
  && cargo install --git https://gitlab.com/chevdor/srtool-cli \
  && cargo install --git https://github.com/alacritty/alacritty \
  && cargo install --locked evcxr_jupyter \
  && curl -L https://foundry.paradigm.xyz | bash \
  && ~/.foundry/bin/foundryup \
  && curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/dotfiles/alacritty/alacritty.yml --retry-delay 2 --retry 3 \
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
  && curl https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN curl -fsSL https://sh.iroh.computer/install_laptop.sh | sh

RUN sudo add-apt-repository ppa:jonathonf/vim \
  && sudo add-apt-repository ppa:neovim-ppa/unstable \
  && sudo add-apt-repository ppa:ethereum/ethereum \
  && sudo apt update -y \
  && sudo apt install -y vim neovim solc ethereum \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade pipenv \
  && pip3 install "pix2tex[gui]" \
  && pip3 install --upgrade solc-select \
  && python3 -m pip install -U "yt-dlp[default]" \
  && pip3 inssall --user cmakelang \
  && pip3 install --user cmake-language-server \
  && pip3 install --user jupyter \
  && pip3 install --user ninja \
  && pip3 install --user you-get \
  && pip3 install --user codespell \
  && pip3 install --user detect-secrets \
  && pip3 install --user wheel \
  && pip3 install --user smdv \
  && pip3 install --user neovim-remote \
  && pip3 install --user panoramix-decompiler \
  && pip3 install --user cmake-format \
  && pip3 install --user -U jedi \
  && pip3 install --user pynvim \
  && pip3 install --user awscli \
  && pip3 install --user maturin \
  && pip3 install --user poetry \
  && sudo gem install neovim \
  && curl -fo ~/.vimrc https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/coc/.vimrc --retry-delay 2 --retry 3 \
  && curl -fo ~/.vim/coc-settings.json --create-dirs https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/coc/coc-settings.json --retry-delay 2 --retry 3 \
  && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://cdn.jsdelivr.net/gh/junegunn/vim-plug/plug.vim --retry-delay 2 --retry 3 \
  && if [ ! -d ~/.config ]; then mkdir ~/.config; fi \
  && ln -s ~/.vim ~/.config/nvim \
  && ln -s ~/.vimrc ~/.config/nvim/init.vim \
  && nvim --headless +PlugInstall +qall \
  && nvim --headless +VimspectorInstall +qall \
  && curl -fo ~/.vimspector.json --create-dirs https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/vimspector/.vimspector.json --retry-delay 2 --retry 3 \
  && if [ ! -d ~/.config/coc/extensions ]; then mkdir -p ~/.config/coc/extensions; fi \
  && curl -fo ~/.config/coc/extensions/package.json https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/coc/package.json --retry-delay 2 --retry 3 \
  && cd ~/.config/coc/extensions \
  && npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod \
  && curl -fo ~/.vim/tasks.ini https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/asynctasks/tasks.ini --retry-delay 2 --retry 3 \
  && curl -fo --create-dirs ~/.config/coc/ultisnips/rust.snippets https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/snippets/rust.snippets --retry-delay 2 --retry 3 \
  && curl -fo --create-dirs ~/.config/coc/ultisnips/typescript.snippets https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/snippets/typescript.snippets --retry-delay 2 --retry 3 \
  && curl -fo --create-dirs ~/.config/coc/ultisnips/solidity.snippets https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/snippets/solidity.snippets --retry-delay 2 --retry 3 \
  && curl -fo --create-dirs ~/.config/coc/ultisnips/go.snippets https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/snippets/go.snippets --retry-delay 2 --retry 3

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
  && curl -fLo ~/.tmux.conf --create-dirs https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/tmux/.tmux.conf --retry-delay 2 --retry 3 \
  && curl -fLo ~/.tmuxline_snapshot --create-dirs https://cdn.jsdelivr.net/gh//GopherJ/dotfiles/tmux/.tmuxline_snapshot --retry-delay 2 --retry 3

RUN git clone https://github.com//GopherJ/dotfiles ~/dotfiles \
  && cd ~/dotfiles/fonts \
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
