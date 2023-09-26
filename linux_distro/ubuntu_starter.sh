#!/usr/bin/env bash

set -e
echo "basic installation for a new ubuntu desktop environment"
######

me=$(whoami)
SUDO=""
APT=apt
if [ "${me}" != "root" ]; then
    SUDO=sudo
fi

if [ $(command -v lsb_release) ]; then
    ubuntu_codename=$(lsb_release -cs)
else
    ubuntu_codename=$(grep -E '^UBUNTU_CODENAME=' /etc/os-release | grep -Eo '[a-z]+')
fi
echo "ubuntu codename: ${ubuntu_codename}"


$SUDO $APT install -y wget
$SUDO $APT install -y build-essential binutils gdb
# $SUDO $APT install -y autoconf automake libtool
$SUDO $APT install -y vim tree zip unzip
$SUDO $APT install -y software-properties-common
$SUDO $APT install -y openssh-client
# $SUDO $APT install -y ugrep
$SUDO $APT install -y ripgrep

# $SUDO add-apt-repository ppa:deadsnakes/ppa

## vscode, use deb version, because snap/snapcraft version has cjk input issue
# if [ ! -e "vscode_amd64.deb" ]; then
    # wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O vscode_amd64.deb
    # $SUDO $APT install ./vscode_amd64.deb
# fi

# git:
$SUDO $APT install -y git
git config --global core.editor vim
git config --global diff.tool vimdiff
# $SUDO snap install sublime-merge --edge --classic

# conda:
if ! command -v conda > /dev/null; then
    if [ ! -e "Miniconda3-latest-Linux-x86_64.sh" ]; then
        wget -nc https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
    fi
    sh Miniconda3-latest-Linux-x86_64.sh
fi

# zsh:
$SUDO $APT install -y zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    REMOTE=https://gitee.com/mirrors/oh-my-zsh.git sh -c "$(wget -qO- https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
fi

echo 'DONE'
