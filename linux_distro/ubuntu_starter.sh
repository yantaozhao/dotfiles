#! /bin/bash

set -e
echo "starter configuration for a new ubuntu environment"
######

me=$(whoami)
SUDO=""
APT=apt
mode=0
if [ "${me}" != "root" ]; then
    SUDO=sudo
fi

echo "Choose your environment:"
echo " ubuntu desktop: 0*"
echo " ubuntu docker : 1"
ui=""
read ui
case "${ui}" in
0)
    mode=0
    echo "You chose ubuntu desktop"
    ;;
1)
    mode=1
    echo "You chose ubuntu docker"
    ;;
*)
    mode=0
    echo "default as ubuntu desktop"
    ;;
esac

echo "(apt mirror is recommended for speedup the installation!)"
ui=""
read -p "Change apt mirror to tuna-tsinghua? [y/N]" ui
# https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
if [ "${ui}" = "y" ]; then
    $SUDO cp -aiv /etc/apt/sources.list /etc/apt/sources.list.orig
    if [ $(command -v lsb_release) ]; then
        ubuntu_codename=$(lsb_release -cs)
    else
        ubuntu_codeinfo=$(grep -Fi "UBUNTU_CODENAME" /etc/os-release)
        ubuntu_codename=${ubuntu_codeinfo##UBUNTU_CODENAME=}
    fi
    echo "ubuntu codename: ${ubuntu_codename}"

    cat <<EOF | $SUDO tee /etc/apt/sources.list
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename} main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename} main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-updates main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-updates main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-backports main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-backports main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-security main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${ubuntu_codename}-security main restricted universe multiverse
EOF
fi

ui=""
read -p "Run: '$SUDO $APT update'? [y/N]" ui
if [ "${ui}" = "y" ]; then
    $SUDO $APT -y update
fi

######
set -x

### ubuntu docker ###
if [ "${mode}" -eq "1" ]; then
    $SUDO unminimize || true
fi

### common ###
$SUDO $APT install -y wget
$SUDO $APT install -y build-essential binutils gdb
$SUDO $APT install -y autoconf automake libtool
$SUDO $APT install -y vim tree git
$SUDO $APT install -y openssh-client
$SUDO $APT install -y zsh
$SUDO $APT install -y software-properties-common
$SUDO $APT install -y lsb-release
$SUDO $APT install -y bc

if (($(echo "$(lsb_release -rs) >= 19.04" | bc -l))); then
    $SUDO $APT install -y ripgrep
    $SUDO $APT install -y fd-find
fi

### ubuntu desktop ###
if [ "${mode}" -eq "0" ]; then
    $SUDO $APT install -y unar

    ui=""
    read -p "Install packages using snap? [y/N]" ui
    if [ "${ui}" = "y" ]; then
        $SUDO snap install sublime-text --classic
        $SUDO snap install code --classic
        $SUDO snap install node --classic
        npm config set registry https://registry.npm.taobao.org
        npm config set ELECTRON_MIRROR=https://npm.taobao.org/mirrors/electron/
        # $SUDO snap install chromium
        $SUDO snap install xmind
    fi
fi

### ubuntu docker ###
if [ "${mode}" -eq "1" ]; then
    ## TODO: en_US.UTF-8
    $SUDO $APT install -y language-pack-en-base
    # $SUDO locale-gen
    # $SUDO update-locale LANG=en_US.UTF-8

    # node
    wget https://deb.nodesource.com/setup_lts.x -O node_setup_lts.x
    if [ "${me}" != "root" ]; then
        $SUDO -E bash node_setup_lts.x
    else
        bash node_setup_lts.x
    fi
    $SUDO $APT -y update
    $SUDO $APT install -y nodejs

    # ssh server
    echo "Please set passwd before using ssh login:"
    if [ -z "$(echo $(passwd --status) | grep -F ' P ')" ]; then
        $SUDO passwd
    fi
    $SUDO $APT install -y openssh-server
    $SUDO sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    $SUDO sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

    echo "ip: $(hostname -I)"
    service ssh status || true

    OMZ_INSTALLER_OPTION="--unattended"
fi

### install: ohmyzsh ###
ui=""
read -p "install ohmyzsh? [y/N]" ui
# https://github.com/ohmyzsh/ohmyzsh
if [ "${ui}" = "y" ]; then
    OMZDIR=${HOME}/.oh-my-zsh
    if [ ! -d "${OMZDIR}" ]; then
        pushd .
        REMOTE=https://gitee.com/mirrors/oh-my-zsh.git sh -c "$(wget -qO- https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh) ${OMZ_INSTALLER_OPTION}"
        if [ -d "${OMZDIR}/custom/plugins" ]; then
            cd ${OMZDIR}/custom/plugins
            [ ! -d "zsh-autosuggestions" ] && git clone --verbose https://gitee.com/yantaozhao/zsh-autosuggestions.git
            [ ! -d "fast-syntax-highlighting" ] && git clone --verbose https://gitee.com/yantaozhao/fast-syntax-highlighting.git
        fi
        cp -iv ${HOME}/.zshrc ${HOME}/.zshrc.orig
        sed -i 's/^[^#]*ZSH_THEME=.*/ZSH_THEME="simple"/' ${HOME}/.zshrc
        sed -i 's/^plugins=(git)$/plugins=(colored-man-pages zsh-navigation-tools zsh-autosuggestions)/' ${HOME}/.zshrc
        popd
    else
        echo "${OMZDIR} already exists!"
    fi
fi
