#! /bin/bash

set -ex
echo "starter configuration for a new fedora docker container"

if [ -z "$(grep 'fastestmirror' /etc/dnf/dnf.conf)" ]; then
    pushd .
    cd /etc/dnf/
    cp -iv dnf.conf dnf.conf.orig
    echo "fastestmirror=True" >>dnf.conf
    popd
fi

dnf -y check-update || true
dnf -y distro-sync
dnf -y group install "Minimal Install"
dnf -y group install "C Development Tools and Libraries"
dnf -y install wget vim tree zsh
dnf -y install ripgrep fd-find

## ssh
ssh-keygen -A
sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
# passwd
# sshd -D
