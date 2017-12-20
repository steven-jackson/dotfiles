#!/bin/bash

set -o pipefail

packages=""

function add_packages() {
    packages="$packages $@"
}

if [ "$(uname)" = "Darwin" ]; then
    readonly os_name="mac"
    readonly has_gui=true
else
    source /etc/os-release
    readonly os_name=$ID

    if [ "$os_name" = "ubuntu" ]; then
        readonly os_codename=$(lsb_release -cs)
    else
        readonly os_codename=""
    fi

    if [ "$XDG_SESSION_TYPE" != "" ]; then
        readonly has_gui=true
    else
        readonly has_gui=false
    fi
fi

./install-configs.sh

# so at this point the next installers have access to:
#    add_packages
#     $packages, $os_name, $os_codename, $has_gui

if [ "$os_codename" != "" ]; then
    source $os_name/$os_codename/install.sh &> /dev/null
fi

source $os_name/install.sh

# TODO: Only if running X
if $has_gui; then
    xrdb -load ~/.Xdefaults
fi

if [[ ! -d ~/.local/share/omf ]]; then
    curl -L https://get.oh-my.fish | fish
    omf install bobthefish
fi

pip install --user --upgrade \
    pylint \
    pynvim

rustup default stable

rustup component add \
    clippy \
    rls \
    rustfmt \
    rust-analysis

cargo install \
    hyperfine \
    ripgrep
