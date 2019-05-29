#!/bin/bash
#
## Install packages as startup on a new ubuntu os.
## Usage: bash this_script.sh [-f]


FORCEMODE=
while getopts ":f" opt; do
    case "$opt" in
        "f")
            FORCEMODE=1
            echo "force mode"
        ;;
    esac
done


sudo apt install wget
# sudo apt install curl
sudo apt install aria2

## git:
sudo apt install git
sudo apt install gitk
if [[ ! -f $HOME/.gitalias.txt ]] || [[ $FORCEMODE ]]; then
    echo 'configuring git'
    aria2c https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt -o ~/.gitalias.txt
    sleep 1
    git config --global include.path ~/.gitalias.txt
fi

sudo apt install bash-completion
sudo apt install vim
sudo apt install tree
sudo apt install build-essential
sudo apt install autoconf automake libtool
sudo apt install make
# sudo apt install cmake
sudo apt install gcc g++ gdb
sudo apt install openssh-client openssh-server
sudo apt install openjdk-8-jdk

## tmux:
sudo apt install tmux
# TODO: .tmux.conf

## zsh, ripgrep, fd:
pushd .
if [ -d $HOME/Downloads ]; then
    cd $HOME/Downloads
else
    cd /tmp
fi

## zsh:
sudo apt install zsh
ZSHRC="$HOME/.zshrc"
if [[ ! -d $HOME/.oh-my-zsh ]] || [[ $FORCEMODE ]]; then
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

if [[ ! `command -v rg` ]] || [[ $FORCEMODE ]]; then
    echo 'installing ripgrep'
    aria2c https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
    sudo dpkg -i ripgrep_11.0.1_amd64.deb
    if [ -f $ZSHRC ]; then
        echo -e "if command -v rg &> /dev/null; then alias rg=\"rg -u\"; fi" >> $ZSHRC
    fi
fi

if [[ ! `command -v fd` ]] || [[ $FORCEMODE ]]; then
    echo 'installing fd'
    aria2c https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb
    sudo dpkg -i fd_7.3.0_amd64.deb
    if [ -f $ZSHRC ]; then
        echo -e "if command -v fd &> /dev/null; then alias fd=\"fd -s -HI\"; fi" >> $ZSHRC
    fi
fi
popd


## vscodium:
read -p "Do you want to install vscodium? [y/N]" yn
if [[ "$yn" = "y" ]] || [[ "$yn" = "Y" ]]; then
    if [[ ! `command -v vscodium` ]] || [[ $FORCEMODE ]]; then
        echo 'installing vscodium'
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
        echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
        sudo apt update
        sudo apt install vscodium
    fi
fi

