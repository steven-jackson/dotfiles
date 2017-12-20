#/bin/bash

set -e

if ! command -v brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

in_vm=false
if ioreg -l | grep "VMware Virtual USB" > /dev/null; then
    in_vm=true
fi

brew install \
        fish \
        nvim \
        vimpager

if ! $in_vm; then
    brew install \
        ccache \
        cmake \
        git \
        stow \
        tmux

    brew cask install \
        spotify \
        visual-studio-code

    gem install \
        tmuxinator
fi

brew tap homebrew/cask-fonts
brew cask install font-fira-code
