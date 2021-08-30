#! /bin/bash

set -e
echo "starter configuration for a new ubuntu environment"
######

yn=$1
echo "yn :${yn}:"

mode=0
me=$(whoami)
SUDO=""
APT=apt
if [ "${me}" != "root" ]; then
    SUDO=sudo
fi

if [ $(command -v lsb_release) ]; then
    ubuntu_codename=$(lsb_release -cs)
else
    # ubuntu_codeinfo=$(grep -Fi "UBUNTU_CODENAME" /etc/os-release)
    # ubuntu_codename=${ubuntu_codeinfo##UBUNTU_CODENAME=}
    ubuntu_codename=$(grep -E '^UBUNTU_CODENAME=' /etc/os-release | grep -Eo '[a-z]+')
fi
echo "ubuntu codename: ${ubuntu_codename}"

function ask() {
    i=$1
    printf "input: %s? " $i >&2
    if [ -z "${yn}" ]; then
        read iu
        if [ -n "${iu}" ]; then
            i=$iu
        fi
    fi
    printf "\n" >&2

    echo ${i,,}
}

echo "Choose your environment:"
echo " ubuntu desktop: 0*"
echo " ubuntu docker : 1"
read -p "input 0? " i
case "${i}" in
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

echo "Change apt mirror to tuna-tsinghua? [y/N]"
# https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
if [ "$(ask 'n')" = "y" ]; then
    $SUDO cp -aiv /etc/apt/sources.list /etc/apt/sources.list.orig
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

echo "Run: '$SUDO $APT update'? [Y/n]"
if [ "$(ask 'y')" = "y" ]; then
    $SUDO $APT -y update
fi
# $SUDO $APT upgrade

######
# set -x

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
$SUDO $APT install -y software-properties-common
$SUDO $APT install -y lsb-release
$SUDO $APT install -y bc

if (($(echo "$(lsb_release -rs) >= 19.04" | bc -l))); then
    # $SUDO $APT install -y ripgrep fd-find
fi

### ubuntu desktop ###
if [ "${mode}" -eq "0" ]; then
    $SUDO $APT install -y unar
    
    # rime input
    $SUDO $APT -y install ibus-rime librime-data-double-pinyin
    mkdir -p ${HOME}/.config/ibus/rime/ || true
    cat <<EOF | tee ${HOME}/.config/ibus/rime/default.custom.yaml
patch:
  schema_list:
    # - schema: luna_pinyin          # 朙月拼音
    - schema: double_pinyin        # 自然碼雙拼

  menu/page_size: 9
EOF

    # vscode
    # $SUDO snap install code --classic
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode_amd64.deb
    $SUDO $APT install ./vscode_amd64.deb

    echo "Install packages using snap? [y/N]"
    if [ "$(ask ${yn})" = "y" ]; then
        $SUDO snap install sublime-text --classic
        $SUDO snap install sublime-merge --classic
        $SUDO snap install node --classic
        npm config set registry https://registry.npm.taobao.org
        npm config set ELECTRON_MIRROR=https://npm.taobao.org/mirrors/electron/
        # $SUDO snap install chromium
    fi

    echo "Install wine apt source? [y/N]"
    if [ "$(ask ${yn})" = "y" ]; then
        $SUDO dpkg --add-architecture i386
        wget -qO- https://dl.winehq.org/wine-builds/winehq.key | $SUDO apt-key add -
        $SUDO add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${ubuntu_codename} main"
        # sudo apt install --install-recommends winehq-{stable,devel}
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


echo "Install Miniconda? [y/N]"
if [ "$(ask ${yn})" = "y" ]; then
    wget -nc https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh && sh Miniconda3-latest-Linux-x86_64.sh
    cat <<EOF | tee ${HOME}/.condarc
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
fi

# pip
mkdir -v ${HOME}/.pip/
cat <<EOF | tee ${HOME}/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF

echo "Install llvm apt source? [y/N]"
if [ "$(ask ${yn})" = "y" ]; then
    cat <<EOF | $SUDO tee /etc/apt/sources.list.d/llvm_latest.list
        deb http://apt.llvm.org/${ubuntu_codename}/ llvm-toolchain-${ubuntu_codename} main
        deb-src http://apt.llvm.org/${ubuntu_codename}/ llvm-toolchain-${ubuntu_codename} main
EOF
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | $SUDO apt-key add -
fi

echo "Install ohmyzsh? [y/N]"
# https://github.com/ohmyzsh/ohmyzsh
if [ "$(ask ${yn})" = "y" ]; then
    $SUDO $APT install -y zsh

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

echo 'DONE'
