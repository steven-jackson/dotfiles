#!/bin/bash

require_update=false

add_packages \
    clang \
    cmake \
    curl \
    exuberant-ctags \
    fonts-powerline \
    git \
    libclang-dev \
    mlocate \
    python3-pip \
    tmux \
    valgrind

if ! command -v nvim > /dev/null; then
    add_packages neovim
    sudo add-apt-repository ppa:neovim-ppa/stable
    require_update=true
fi

if ! command -v swift > /dev/null; then
    add_packages swift
    curl -L https://repo.vapor.codes/apt/keyring.gpg | sudo apt-key add -
    echo "deb https://repo.vapor.codes/apt $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/vapor.list
    require_update=true
fi

if ! command -v spotify > /dev/null; then
    snap install spotify
fi

if ! command -v signal-desktop > /dev/null; then
    snap install signal-desktop
fi

if $has_gui; then
    add_packages \
        adwaita-icon-theme-full \
        arc-theme \
        evolution \
        firefox \
        fonts-powerline \
        msttcorefonts \
        nautilus-dropbox \
        steam
fi

if $require_update; then
    sudo apt-get update
fi

sudo snap refresh

sudo apt-get install -y $packages
