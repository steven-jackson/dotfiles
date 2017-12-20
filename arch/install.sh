#!/bin/bash

if ! command -v curl &> /dev/null; then
    sudo pacman -S --noconfirm --needed curl
fi

if ! pacman -Qi base-devel &> /dev/null; then
    sudo pacman -S --noconfirm --needed base-devel
fi

if ! command -v yay &> /dev/null; then
    pushd $(mktemp -d)
    curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay" > PKGBUILD
    makepkg -si
    popd
fi

add_packages \
    bash-completion \
    clang \
    cmake \
    cppcheck \
    ctags \
    curl \
    gist \
    git \
    mlocate \
    neovim \
    openssh \
    python-pip \
    rustup \
    sparse \
    stow \
    tmux \
    ttf-dejavu-sans-mono-powerline-git

if $has_gui; then
    add_packages \
        arc-gtk-theme \
        brave-bin \
        gnome-tweak-tool \
        lutris \
        noto-fonts-emoji \
        otf-fira-code \
        spotify \
        steam \
        visual-studio-code-insiders
fi

yay -S --noconfirm --needed $packages
