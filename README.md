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

```
alias vimdocker='docker run -it -v "$(pwd)":/home/alex_cj96/src alexcj96/vim-docker-env:latest'
vimdocker
```

## Screenshots

![vim](./images/vim.png)
![ls](./images/ls.png)

## Todo

- add common cxx dependencies like boost, dlib, paho, geographiclib...
- passing `GITHUB_TOKEN`, `GITLAB_TOKEN` to container so that command like `:GBrowse` makes sense
- minimize
- sshd
