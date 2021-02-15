FROM ubuntu:20.04
MAINTAINER Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96
ARG GO_VERSION=1.15.7
ARG NODE_VERSION=v12.20.1
ARG RUST_TOOLCHAIN=nightly-2021-01-25
ARG TABNINE_VERSION=3.3.35
ARG RUST_ANALYZER_VERSION=2021-01-25

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
        build-essential \
        mingw-w64 \
        libncurses5-dev \
        libncursesw5-dev \
        debhelper \
        inotify-tools \
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
        imagemagick \
        clangd-11 \
        clang-11 \
        libjansson-dev \
        protobuf-compiler \
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
    && sudo ln -s $(pwd)/vcpkg /usr/local/bin \
    && vcpkg install spdlog nlohmann-json

RUN git clone https://github.com/syndbg/goenv.git ~/.goenv \
    && eval "$(goenv init -)" \
    && goenv install $GO_VERSION \
    && goenv global $GO_VERSION \
    && goenv rehash \
    && go get -u github.com/go-delve/delve/cmd/dlv \
    && go get -u github.com/golang/protobuf/protoc-gen-go

RUN curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm/v0.37.2/install.sh | bash \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" \
    && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node" \
    && sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm" \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm install-latest-npm \
    && npm install -g yarn @vue/cli vls typescript eslint eslint-plugin-vue prettier neovim

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN} --component rust-src --target x86_64-pc-windows-gnu --target x86_64-apple-darwin \
    && cargo install cargo-edit \
    && cargo install exa \
    && cargo install zoxide \
    && cargo install bat \
    && cargo install install cargo-whatfeatures --no-default-features --features "rustls" \
    && cargo install --git https://github.com/alacritty/alacritty --tag v0.6.0 \
    && curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs https://cdn.jsdelivr.net/gh/GopherJ/cfg/alacritty/alacritty.yml --retry-delay 2 --retry 3 \
    && cargo install --git https://github.com/extrawurst/gitui \
    && cargo install --git https://github.com/sharkdp/bat --tag v0.17.1 \
    && cargo install --git https://github.com/sharkdp/fd \
    && git clone https://github.com/rust-analyzer/rust-analyzer.git \
    && cd rust-analyzer \
    && git checkout $RUST_ANALYZER_VERSION \
    && cargo xtask install --server

RUN git clone https://github.com/tpoechtrager/osxcross \
    && cd osxcross \
    && wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz \
    && mv MacOSX10.10.sdk.tar.xz tarballs \
    && UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- -t robbyrussell \
    && curl https://cdn.jsdelivr.net/gh/GopherJ/cfg/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Homebrew/install/install.sh)" \
    && /home/linuxbrew/.linuxbrew/bin/brew install watchman \
    && /home/linuxbrew/.linuxbrew/bin/brew install gh

RUN sudo add-apt-repository ppa:ethereum/ethereum \
    && sudo apt update \
    && sudo apt install solc

RUN sudo add-apt-repository ppa:jonathonf/vim \
    && sudo add-apt-repository ppa:neovim-ppa/unstable \
    && sudo apt update \
    && sudo apt install -y vim neovim \
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
    && curl -fo ~/.vim/tasks.ini https://cdn.jsdelivr.net/gh/GopherJ/cfg/asynctasks/tasks.ini --retry-delay 2 --retry 3

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

WORKDIR /home/${APP_USER}/src

EXPOSE 9999

CMD ["sudo", "/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
