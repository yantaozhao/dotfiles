#! /bin/bash

set -e
echo "starter configuration for a new fedora environment"

mode=0
me=$(whoami)
SUDO=""
if [ "${me}" != "root" ]; then
    SUDO=sudo
fi
fedora_version=$(grep -E '^VERSION_ID=' /etc/os-release | grep -Po '\d+')
echo "fedora version: ${fedora_version}"

echo "Choose your environment:"
echo " fedora desktop: 0*"
echo " fedora docker : 1"
i=''
read -p "input 0? " i
case "${i}" in
0)
    mode=0
    echo "You chose fedora desktop"
    ;;
1)
    mode=1
    echo "You chose fedora docker"
    ;;
*)
    mode=0
    echo "default as fedora desktop"
    ;;
esac


if [ -z "$(grep 'fastestmirror' /etc/dnf/dnf.conf)" ]; then
    pushd .
    cd /etc/dnf/
    cp -iv dnf.conf dnf.conf.orig
    cat "fastestmirror=True" | $SUDO tee -a dnf.conf
    popd
fi

dnf -y check-update || true
# $SUDO dnf -y distro-sync
$SUDO dnf -y group install "Minimal Install"
$SUDO dnf -y group install "C Development Tools and Libraries"
$SUDO dnf -y install wget vim tree git
# $SUDO dnf -y install ripgrep fd-find

git config --global core.editor "vim"


if [ "${mode}" -eq "0" ]; then
    # rime input
    $SUDO dnf -y install ibus-rime
    mkdir -p ${HOME}/.config/ibus/rime/ || true
    cat << EOF | tee ${HOME}/.config/ibus/rime/default.custom.yaml
patch:
  schema_list:
    # - schema: luna_pinyin          # 朙月拼音
    - schema: double_pinyin        # 自然碼雙拼

  menu/page_size: 9
EOF

    # snap
    $SUDO dnf -y install snapd
    $SUDO ln -v -s /var/lib/snapd/snap /snap || true

    ## other packages
    # vscode
    $SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    $SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # winehq
    # $SUDO dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/${fedora_version}/winehq.repo

    dnf check-update
    $SUDO dnf -y install code
    # $SUDO dnf install winehq-{stable,devel}
fi


if [ "${mode}" -eq "1" ]; then
    ## ssh
    ssh-keygen -A
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
    # passwd
    # sshd -D
fi


i=''
read -p "Install Miniconda? [y/N]" i
if [ "${i}" = "y" ]; then
    if [ ! -e "Miniconda3-latest-Linux-x86_64.sh" ]; then
        wget -nc https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh && sh Miniconda3-latest-Linux-x86_64.sh
    fi
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
mkdir -v ${HOME}/.pip/ || true
cat <<EOF | tee ${HOME}/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF


i=''
read -p "Install ohmyzsh? [y/N]" i
# https://github.com/ohmyzsh/ohmyzsh
if [ "${i}" = "y" ]; then
    $SUDO dnf -y install zsh

    OMZDIR=${HOME}/.oh-my-zsh
    if [ ! -d "${OMZDIR}" ]; then
        pushd .
        OMZ_INSTALLER_OPTION="--unattended"
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
