#!/bin/bash
#
## Install packages as startup on a new ubuntu os.
## Usage: bash this_script.sh [-f]

APTCMD=apt

FORCEMODE=
while getopts ":f" opt; do
    case "$opt" in
        "f")
            FORCEMODE=1
            echo "force mode"
        ;;
    esac
done

read -p "Run: sudo $APTCMD update? [y/N]" yn
if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
    sudo $APTCMD update
fi

sudo $APTCMD install wget
# sudo $APTCMD install curl
sudo $APTCMD install aria2

## git:
sudo $APTCMD install git
sudo $APTCMD install gitk
if [[ ! -f $HOME/.gitalias.txt ]]; then
    read -p "Configure git using gitalias? [y/N]" yn
    if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
        echo 'configuring git'
        aria2c https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt -o ~/.gitalias.txt
        sleep 1
        git config --global include.path ~/.gitalias.txt
    fi
fi

sudo $APTCMD install bash-completion
sudo $APTCMD install vim
sudo $APTCMD install tree
sudo $APTCMD install build-essential
sudo $APTCMD install autoconf automake libtool
sudo $APTCMD install make
# sudo $APTCMD install cmake
sudo $APTCMD install gcc g++ gdb
sudo $APTCMD install openssh-client openssh-server

# jdk
read -p "Install openjdk-8? [y/N]" yn
if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
    sudo $APTCMD install openjdk-8-jdk
fi

## tmux:
sudo $APTCMD install tmux
# TODO: .tmux.conf

## zsh, ripgrep, fd:
pushd .
if [ -d $HOME/Downloads ]; then
    cd $HOME/Downloads
else
    cd /tmp
fi

## zsh:
sudo $APTCMD install zsh
ZSHRC="$HOME/.zshrc"
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    read -p "Configure zsh using oh-my-zsh? [y/N]" yn
    if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
        echo 'configuring oh-my-zsh'
        # sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        aria2c https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o omz_install.sh
        sh omz_install.sh
        sleep 1
        if [ -f $ZSHRC ]; then
            cp -iv $ZSHRC $ZSHRC.orig
            sed -i 's/^[^#]*ZSH_THEME=.*/ZSH_THEME="af-magic"/' $ZSHRC
            sed -i 's/^plugins=(git)$/plugins=(git colored-man-pages)/' $ZSHRC
        else
            echo "Warning: $ZSHRC not found!"
        fi
    fi
fi

if [[ ! `command -v rg` ]]; then
    read -p "Install ripgrep? [y/N]" yn
    if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
        echo 'installing ripgrep'
        aria2c https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
        sudo dpkg -i ripgrep_11.0.1_amd64.deb
        if [ -f $ZSHRC ]; then
            echo -e "if command -v rg &> /dev/null; then alias rg=\"rg -u\"; fi" >> $ZSHRC
        else
            echo "Warning: $ZSHRC not found!"
        fi
    fi
fi

if [[ ! `command -v fd` ]]; then
    read -p "Install fd? [y/N]" yn
    if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
        echo 'installing fd'
        aria2c https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb
        sudo dpkg -i fd_7.3.0_amd64.deb
        if [ -f $ZSHRC ]; then
            echo -e "if command -v fd &> /dev/null; then alias fd=\"fd -s -HI\"; fi" >> $ZSHRC
        else
            echo "Warning: $ZSHRC not found!"
        fi
    fi
fi
popd


## vscodium:
if [[ ! `command -v vscodium` ]]; then
    read -p "Install vscodium from PPA? [y/N]" yn
    if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
        echo 'installing vscodium'
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
        echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
        sudo $APTCMD update
        sudo $APTCMD install vscodium
    fi
fi

