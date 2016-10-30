#!/bin/bash

#Author:zyt
#OS:ubuntu
#
#~/.vimrc                   :'cp /etc/vim/vimrc ~/.vimrc'
#~/.vim/                    :plugins directory
#~/.vim/bundle/Vundle.vim/  :Vundle directory
#~/.vim/vimrc_user          :your vim configuration file
#
#This script will:
#append and source your_configuration_file to ~/.vimrc
#and,place plugins in ~/.vim/
#
#If want back to initial vim:remove ~/.vim/ and reset ~/.vimrc
#----------

if [ ${PWD} != ${HOME} ]; then
  echo 'Error:place and run this script in $HOME directory. exit'
  exit 1
fi

vundleDir=.vim/bundle/Vundle.vim
myCfgFile=.vim/vimrc_user
vundleGitUrl=https://github.com/VundleVim/Vundle.vim.git

# check file and directory
if [ ! -f ${HOME}/.vimrc ]; then
  echo '~/.vimrc not exist, exit'
  exit 1
fi

if [ -d ${HOME}/.vim ]; then
  echo 'directory ~/.vim/ already exist,but I will use it,'
  echo 'backup is recommended before continue if you run this script the 1st time,'
  read -p 'press any key to continue if you have done...'
fi

# download Vundle and your configuration file
if [ ! -d ${HOME}/${vundleDir} ]; then
  read -p 'Press any key to start download Vundle...'
  git clone ${vundleGitUrl} ${HOME}/${vundleDir}
fi

if [ ! -f ${HOME}/${myCfgFile} ]; then
  #TODO:curl to download it
  echo "your configuration file not found"
fi

# source your configuration
if [ -f ${HOME}/${myCfgFile} ]; then
  if grep -En "source\s+.*${myCfgFile}" ~/.vimrc ; then
    echo 'Maybe you have done source your configuration in ~/.vimrc already,'
    read -p 'press any key to continue...'
  else
    read -p 'Press any key to append source statement to ~/.vimrc'
    echo '" Source user configuration if available' >> ~/.vimrc
    echo "if filereadable(\"${HOME}/${myCfgFile}\")" >> ~/.vimrc
    echo "  source ${HOME}/${myCfgFile}" >> ~/.vimrc
    echo "endif" >> ~/.vimrc
    echo '' >> ~/.vimrc
  fi
else
  echo 'Error:your configuration file not found,exit'
  exit 1
fi

# using Vundle to manage plugins
read -p 'Press any key to start install plugins using Vundle...'
vim +PluginInstall +PluginClean +qall

