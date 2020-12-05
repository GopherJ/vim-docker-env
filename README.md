# vim-docker-env
vim docker development environment

## Features

- vim & neovim
- coc.nvim
- a bunch of awesome coc extensions
- alacritty
- tmux
- fira code fonts
- go, rust, node
- autojump
- built in multiple languages vim config
- ripgrep, fd, exa...

## Usage

1. enter docker for working
```
alias vimdocker='docker run --rm -it -v "$(pwd)":/home/alex_cj96/src alexcj96/vim-docker-env:latest zsh'
vimdocker
```

2. launch as ssh daemon

```
docker run -p 9999:9999 alexcj96/vim-docker-env:latest
# Connect: ssh alex_cj96@localhost -p 9999
# Default password: alex_cj96
```

## Screenshots

![vim](./images/vim.png)
![ls](./images/ls.png)

## Todo

- add common cxx dependencies like boost, dlib, paho, geographiclib...
- passing `GITHUB_TOKEN`, `GITLAB_TOKEN` to container so that command like `:GBrowse` makes sense
- minimize
