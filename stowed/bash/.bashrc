ulimit -c unlimited

export CUSTOM_BUILDVERMAJOR=9.9
export AVECTO_DEFENDPOINT_BUILD_VERSION=$CUSTOM_BUILDVERMAJOR
export AVECTO_TARGET_IS_SIP_PROTECTED=1
readonly qt_version=5.14.1
export AVECTO_QT_PATH=~/Qt/$qt_version/clang_64/bin
export TARGET_BUILD_DIR=/Users/steven/Library/Developer/Xcode/DerivedData/Defendpoint-fgbftiezftkbbebxeuagglvuyrtr/Build/Products/Debug
export AVECTO_CERT_APPLICATION="Apple Development"

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/ccache/libexec:$PATH
export PATH=/usr/lib64/ccache:$PATH
export PATH=/usr/lib/ccache:$PATH
export PATH=~/Qt/$qt_version/clang_64/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=/usr/lib/ccache:$PATH
export PATH=~/bin:$PATH
export PATH=/usr/local/opt/ccache/libexec:$PATH
export PATH=$(python3 -m site --user-base)/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"

# for i3's default terminal and editor
export TERMINAL=gnome-terminal

export PYTHON3_SITE_PACKAGES="$(python3 -m site --user-site)"

POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

if [[ $(uname) != Darwin ]]; then
    # if you enter a directory name, it will auto cd in to it
    shopt -s autocd
    shopt -s cdspell
    shopt -s dirspell
    shopt -s globstar
    alias ls='ls --color=auto -h --group-directories-first'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
else
    export CLICOLOR=1
    export PATH=~/Library/Python/2.7/bin:$PATH
    export PATH=/usr/local/opt/ruby/bin:$PATH
    . /usr/local/etc/bash_completion.d/git-completion.bash
    function locate { mdfind "kMDItemDisplayName == '$@'wc"; }
fi

export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"

#source "$PYTHON3_SITE_PACKAGES/powerline/bindings/bash/powerline.sh"

export HISTCONTROL=ignoreboth
shopt -s histappend

# update LINES and COLUMNS after each command
shopt -s checkwinsize

# allow easy editing of multi-line histories
shopt -s cmdhist

shopt -s extglob
shopt -s nocaseglob

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias tmux='tmux -2'

if [ -z $XDG_CONFIG_HOME ]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi

if [ -d $XDG_CONFIG_HOME/bash ]; then
    for file in $XDG_CONFIG_HOME/bash/*; do
        source $file
    done
fi

alias cbcopy="xclip -selection c < $1"

alias ip="ip -color"

is_linux=$(test "$(uname)" = "Linux")

. ~/.dotfiles/bin/work.sh

if command -v nvim &> /dev/null; then
    alias vim=nvim
    alias vimdiff="nvim -d"
fi

export VISUAL=vim
export EDITOR=vim
export MANPAGER="nvim -c 'set ft=man' -"
export PAGER="nvim -R"

