FROM ubuntu:20.04
LABEL Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96
ARG GO_VERSION=1.16.3
ARG NODE_VERSION=v15.14.0
ARG RUST_TOOLCHAIN=nightly-2021-03-25
ARG TABNINE_VERSION=3.3.35
ARG RUST_ANALYZER_VERSION=2021-05-10

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

RUN useradd ${APP_USER} --user-group --create-home --shell /usr/bin/zsh --groups sudo \
        && yes ${APP_USER} | passwd ${APP_USER}

RUN apt update --fix-missing \
    && apt upgrade -y \
    && apt install -y \
        tzdata \
        libssl-dev \
        git \
        wget \
        curl \
        bear \
        nmap \
        build-essential \
        gfortran \
        certbot \
        mingw-w64 \
        libncurses5-dev \
        libncursesw5-dev \
        debhelper \
        inotify-tools \
        watchman \
        ansible \
        sshpass \
        xz-utils \
        gawk \
        unzip \
        zlib1g-dev \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        libxml2-dev \
        libboost-all-dev \
        libarmadillo-dev \
        libjsoncpp-dev \
        libopenblas-dev \
        liblapack-dev \
        uuid-dev \
        sudo \
        ninja-build \
        gfortran \
        xdotool \
        autoconf \
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
        ranger \
        zsh \
        apt-transport-https \
        openjdk-8-jdk \
        protobuf-compiler \
        libprotobuf-dev \
        software-properties-common \
        ca-certificates \
        pkg-config \
        libfreetype6-dev \
        libfontconfig1-dev \
        libxcb-xfixes0-dev \
        libpq-dev \
        imagemagick \
        clangd-11 \
        clang-11 \
        libjansson-dev \
        protobuf-compiler \
        binaryen \
    && update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-11 100 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 1 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-11 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

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

RUN wget https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz \
    && tar -xJf upx-3.94-amd64_linux.tar.xz \
    && chmod u+x upx-3.94-amd64_linux/upx \
    && sudo mv upx-3.94-amd64_linux/upx /usr/local/bin

RUN wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
    && tar -xzvf cmake-3.18.4.tar.gz \
    && cd cmake-3.18.4 \
    && ./bootstrap \
    && make -j4 \
    && sudo make install

RUN curl -fLo ~/ripgrep_12.1.1_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb --retry-delay 2 --retry 3 \
    && sudo dpkg -i ~/ripgrep_12.1.1_amd64.deb

ENV GOENV_ROOT=/home/${APP_USER}/.goenv
ENV NVM_DIR=/home/${APP_USER}/.nvm
ENV CARGO_HOME=/home/${APP_USER}/.cargo
ENV USER=${APP_USER}
ENV VCPKG_ROOT=/home/${APP_USER}/vcpkg

ENV PATH=$CARGO_HOME/bin:$NVM_DIR/versions/node/${NODE_VERSION}/bin:$GOENV_ROOT/bin:$GOENV_ROOT/versions/$GO_VERSION/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${APP_USER}/.local/bin:/home/${APP_USER}/osxcross/target/bin

RUN git clone https://github.com/Microsoft/vcpkg.git \
    && cd vcpkg \
    && ./bootstrap-vcpkg.sh \
    && sudo ln -s $(pwd)/vcpkg /usr/local/bin

RUN git clone https://github.com/tpoechtrager/osxcross \
    && cd osxcross \
    && wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz \
    && mv MacOSX10.10.sdk.tar.xz tarballs \
    && UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

RUN git clone https://github.com/syndbg/goenv.git ~/.goenv \
    && eval "$(goenv init -)" \
    && goenv install $GO_VERSION \
    && goenv global $GO_VERSION \
    && goenv rehash \
    && go get -u github.com/go-delve/delve/cmd/dlv \
    && go get -u github.com/golang/protobuf/protoc-gen-go \
    && go get -u github.com/mgechev/revive

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && sudo apt install apt-transport-https ca-certificates gnupg \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && sudo apt update -y \
    && sudo apt -y install google-cloud-sdk

RUN curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm@v0.37.2/install.sh | bash \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" \
    && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node" \
    && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm" \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm install-latest-npm \
    && npm install -g yarn @vue/cli create-react-app create-near-app vls typescript eslint eslint-plugin-vue prettier neovim truffle near-cli assemblyscript browserify @polkadot/api-cli

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN} --component rust-src --target wasm32-unknown-unknown --target x86_64-pc-windows-gnu --target x86_64-apple-darwin \
    && . /home/${APP_USER}/.cargo/env \
    && curl -fLo ~/.cargo/config --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/cargo/config \
    && cargo install cargo-edit \
    && cargo install cargo-update \
    && cargo install cargo-chef \
    && cargo install --locked cargo-outdated \
    && cargo install exa \
    && cargo install cross \
    && cargo install zoxide \
    && cargo install silicon \
    && cargo install cargo-generate \
    && cargo install basic-http-server \
    && cargo install bat \
    && cargo install diesel_cli --no-default-features --features postgres \
    && cargo install --force --git https://github.com/google/evcxr.git evcxr_repl \
    && cargo install --force --git https://github.com/sgeisler/cargo-remote \
    && cargo install install cargo-whatfeatures --no-default-features --features "rustls" \
    && cargo install --git https://github.com/alacritty/alacritty --tag v0.6.0 \
    && curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/alacritty/alacritty.yml --retry-delay 2 --retry 3 \
    && cargo install --git https://github.com/extrawurst/gitui --tag v0.11.0 \
    && curl -fo ~/.config/gitui/key_config.ron --create-dirs https://cdn.jsdelivr.net/gh/extrawurst/gitui/assets/vim_style_key_config.ron \
    && cargo install --git https://github.com/sharkdp/fd \
    && git clone https://github.com/rust-analyzer/rust-analyzer.git \
    && cargo install --git https://github.com/paritytech/cargo-contract cargo-contract --features extrinsics --force \
    && cargo install --git https://github.com/dtolnay/cargo-expand \
    && cargo install --git https://github.com/vi/websocat --features=ssl \
    && cd rust-analyzer \
    && git checkout $RUST_ANALYZER_VERSION \
    && cargo xtask install --server \
    && curl https://getsubstrate.io -sSf | bash -s \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh


RUN sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh/tools/install.sh)" \
    && curl https://cdn.jsdelivr.net/gh/GopherJ/cfg/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN sudo add-apt-repository ppa:jonathonf/vim \
    && sudo add-apt-repository ppa:neovim-ppa/unstable \
    && sudo add-apt-repository ppa:ethereum/ethereum \
    && sudo apt update \
    && sudo apt install -y vim neovim solc \
    && pip3 install --upgrade pip \
    && pip3 install --user wheel \
    && pip3 install --user cmake-format \
    && pip3 install --user -U jedi \
    && pip3 install --user pynvim \
    && sudo gem install neovim \
    && curl -fo ~/.vimrc https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/.vimrc --retry-delay 2 --retry 3 \
    && curl -fo ~/.vim/coc-settings.json --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/coc-settings.json --retry-delay 2 --retry 3 \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://cdn.jsdelivr.net/gh/junegunn/vim-plug/plug.vim --retry-delay 2 --retry 3 \
    && if [ ! -d ~/.config ]; then mkdir ~/.config; fi \
    && ln -s ~/.vim ~/.config/nvim \
    && ln -s ~/.vimrc ~/.config/nvim/init.vim \
    && if [ ! -d ~/.vim/pack ]; then mkdir ~/.vim/pack; fi \
    && git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector \
    && cd ~/.vim/pack/vimspector/opt/vimspector \
    && ./install_gadget.py \
        --enable-c \
        --enable-go \
        --force-enable-node \
        --enable-rust \
        --force-enable-java \
    && cd - \
    && nvim --headless +PlugInstall +qall \
    && if [ ! -d ~/.config/coc/extensions ]; then mkdir -p ~/.config/coc/extensions; fi \
    && curl -fo ~/.config/coc/extensions/package.json https://cdn.jsdelivr.net/gh/GopherJ/cfg/coc/package.json --retry-delay 2 --retry 3 \
    && cd ~/.config/coc/extensions \
    && npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod \
    && curl -fo ~/.vim/tasks.ini https://cdn.jsdelivr.net/gh/GopherJ/cfg/asynctasks/tasks.ini --retry-delay 2 --retry 3 \
    && curl -fo ~/.config/coc/ultisnips/vim.snippets https://cdn.jsdelivr.net/gh/GopherJ/cfg/snippets/vim.snippets --retry-delay 2 --retry 3

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

RUN curl https://cdn.jsdelivr.net/gh/GopherJ/cfg/fonts/install-fira-code.sh | bash

RUN sudo apt install locales && sudo locale-gen en_US.UTF-8

WORKDIR /home/${APP_USER}/src

EXPOSE 9999

CMD ["sudo", "/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
