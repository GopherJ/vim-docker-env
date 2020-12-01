FROM ubuntu:18.04
MAINTAINER Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96
ARG GO_VERSION=1.14.4
ARG NODE_VERSION=v12.19.0
ARG RUST_TOOLCHAIN=nightly-2020-07-08

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris

RUN useradd ${APP_USER} --user-group --create-home --shell /usr/bin/zsh --groups sudo

RUN apt update --fix-missing \
    && apt upgrade -y \
    && apt install -y \
        tzdata \
        libssl-dev \
        git \
        wget \
        curl \
        build-essential \
        libncurses5-dev \
        libncursesw5-dev \
        debhelper \
        inotify-tools \
        xz-utils \
        gawk \
        unzip \
        zlib1g-dev \
        sudo \
        ninja-build \
        autoconf \
        automake \
        libtool \
        python3-dev \
        python3-pip \
        python-pip \
        tmux \
        clang-format \
        cppcheck \
        ruby \
        ruby-dev \
        apt-file \
        openssh-client \
        openssh-server \
        jq \
        zsh \
        apt-transport-https \
        openjdk-8-jdk \
        protobuf-compiler \
        software-properties-common \
        ca-certificates \
        pkg-config \
        clangd-9 \
        clang-9 \
        libjansson-dev \
    && update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 1 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-9 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && sed -i 's/required/sufficient/1' /etc/pam.d/chsh

USER ${APP_USER}
WORKDIR /home/${APP_USER}
RUN mkdir -p /home/${APP_USER}/src

RUN git clone https://github.com/universal-ctags/ctags ~/ctags \
    && cd ~/ctags \
    && ./autogen.sh \
    && ./configure \
    && make \
    && sudo make install

RUN wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
    && tar -xzvf cmake-3.18.4.tar.gz \
    && cd cmake-3.18.4 \
    && ./bootstrap \
    && make -j4 \
    && sudo make install

RUN curl -fLo ~/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb https://github.com/alacritty/alacritty/releases/download/v0.4.3/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb --retry-delay 2 --retry 3 \
    && sudo dpkg -i ~/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb \
    && curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs https://raw.githubusercontent.com/GopherJ/cfg/master/alacritty/alacritty.yml --retry-delay 2 --retry 3

RUN curl -fLo ~/ripgrep_12.1.1_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb --retry-delay 2 --retry 3 \
    && sudo dpkg -i ~/ripgrep_12.1.1_amd64.deb

ENV GOENV_ROOT=/home/${APP_USER}/.goenv
ENV NVM_DIR=/home/${APP_USER}/.nvm
ENV CARGO_HOME=/home/${APP_USER}/.cargo

ENV PATH=$CARGO_HOME/bin:$NVM_DIR/versions/node/${NODE_VERSION}/bin:$GOROOT/bin:$GOPATH/bin:$GOENV_ROOT/bin:$GOENV_ROOT/versions/$GO_VERSION/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN git clone https://github.com/syndbg/goenv.git ~/.goenv \
    && eval "$(goenv init -)" \
    && goenv install $GO_VERSION \
    && go get -u github.com/go-delve/delve/cmd/dlv

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
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
    sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN} \
    && rustup component add rust-analysis rust-src \
    && cargo install cargo-edit \
    && cargo install exa \
    && cargo install code-minimap \
    && cargo install install cargo-whatfeatures --no-default-features --features "rustls" \
    && cargo install --git https://github.com/xen0n/autojump-rs \
    && curl -fLo ~/.autojump.zsh https://raw.githubusercontent.com/wting/autojump/master/bin/autojump.zsh --retry-delay 2 --retry 3 \
    && cargo install --git https://github.com/sharkdp/fd

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- -t robbyrussell \
    && curl https://raw.githubusercontent.com/GopherJ/cfg/master/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
    && /home/linuxbrew/.linuxbrew/bin/brew install watchman

RUN sudo add-apt-repository ppa:jonathonf/vim \
    && sudo add-apt-repository ppa:neovim-ppa/unstable \
    && sudo apt update \
    && sudo apt install -y vim neovim \
    && pip install wheel \
    && pip3 install wheel \
    && pip install --user pynvim \
    && pip3 install --user pynvim \
    && curl -fo ~/.vimrc https://raw.githubusercontent.com/GopherJ/cfg/master/coc/.vimrc --retry-delay 2 --retry 3 \
    && curl -fo ~/.vim/coc-settings.json --create-dirs https://raw.githubusercontent.com/GopherJ/cfg/master/coc/coc-settings.json --retry-delay 2 --retry 3 \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim --retry-delay 2 --retry 3 \
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
    && curl -fo ~/.config/coc/extensions/package.json https://raw.githubusercontent.com/GopherJ/cfg/master/coc/package.json --retry-delay 2 --retry 3 \
    && cd ~/.config/coc/extensions \
    && npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && curl -fLo ~/.tmux.conf --create-dirs https://raw.githubusercontent.com/GopherJ/cfg/master/tmux/.tmux.conf --retry-delay 2 --retry 3 \
    && curl -fLo ~/.tmuxline_snapshot --create-dirs https://raw.githubusercontent.com/GopherJ/cfg/master/tmux/.tmuxline_snapshot --retry-delay 2 --retry 3

RUN curl https://raw.githubusercontent.com/GopherJ/cfg/master/fonts/install-fira-code.sh | bash

WORKDIR /home/${APP_USER}/src

CMD ["/usr/bin/zsh"]
