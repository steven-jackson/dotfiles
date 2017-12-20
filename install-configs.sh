#!/bin/bash

# If it doesn't exist before stowing, .vim will be a symlink instead of a real
# directory.
mkdir -p ~/.vim

if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
    rm ~/.bashrc
fi

if ! command -v stow > /dev/null; then
    echo "Stow isn't installed"
    exit 1
fi

for d in stowed/*; do
    if [ -d "$d" ]; then
        stow -d stowed -t ~ "$(basename "$d")"
    fi
done

if [[ $(uname) = "Darwin" ]]; then
    ln -s $PWD/stowed/vscode/.config/Code ~/Library/Application\ Support/Code
fi
