#! /usr/bin/env zsh

#
# .zshenv - Zsh environment file, loaded always.
#

export ZDOTDIR=~/.config/zsh
export ZFUNCDIR=~/.config/dotfiles/config/zsh/functions

# XDG
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state
export XDG_RUNTIME_DIR=~/.xdg
export XDG_PROJECTS_DIR=~/Projects

# Custom TODO search usages
export DOTFILES=$XDG_CONFIG_HOME/dotfiles
#export GNUPGHOME=$XDG_DATA_HOME/gnupg
export REPO_HOME=$XDG_CACHE_HOME/repos
export ANTIDOTE_HOME=$REPO_HOME

# Apps
export PNPM_HOME="$HOME/.local/share/pnpm"
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"

export REQUESTS_CA_BUNDLE="/opt/homebrew/etc/openssl@3/cert.pem"

export NVM_SYMLINK_CURRENT=true

# Ensure path arrays do not contain duplicates.
typeset -gU fpath path cdpath

# Set the list of directories that cd searches.
cdpath=(
  $XDG_PROJECTS_DIR(N/)
  $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
    /opt/homebrew/opt/openjdk/bin
    
    # core
    $HOME/{,s}bin(N)
#    $ZDOTDIR/functions(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)

    # apps
    $HOME/miniforge3/bin
    $HOME/.composer/vendor/bin
    $HOME/.local/bin
    $HOME/.local/share/cargo/bin
    # TODO make part of automated install
    
    $PNPM_HOME
    

    $path
)

# Apps
# export EDITOR=hx
# export VISUAL=code
export PAGER=less
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

# Regional settings
export LANG='en_US.UTF-8'
export LC_ALL=en_US.UTF-8

# Misc
export KEYTIMEOUT=1
export SHELL_SESSIONS_DISABLE=1 # Make Apple Terminal behave.for file in $files; do

# Needed for GPG-AGENT: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html#Invoking-GPG_002dAGENT
export GPG_TTY=$(tty)

# Use `< file` to quickly view the contents of any file.
[[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER
