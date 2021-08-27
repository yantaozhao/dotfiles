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


# if [ -z "$(grep 'fastestmirror' /etc/dnf/dnf.conf)" ]; then
#     pushd .
#     cd /etc/dnf/
#     cp -iv dnf.conf dnf.conf.orig
#     echo "fastestmirror=True" >>dnf.conf
#     popd
# fi

$SUDO dnf -y check-update || true
$SUDO dnf -y distro-sync
read -p "distro upgraded. Press any key to continue"

$SUDO dnf -y group install "Minimal Install"
$SUDO dnf -y group install "C Development Tools and Libraries"
$SUDO dnf -y install wget vim tree git
# $SUDO dnf -y install ripgrep fd-find


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

    # vscode
    $SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    $SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # sublime-merge
    # $SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    # $SUDO dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

    # winehq
    # $SUDO dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/${fedora_version}/winehq.repo

    dnf check-update
    $SUDO dnf install code
    # $SUDO dnf install sublime-merge
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
