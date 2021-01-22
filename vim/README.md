# (n)vim configuration


## Description
For vim (vim-nox recommended), or [neovim](https://neovim.io).
- single configuration file: `_vimrc`


## Requirement for installation:
- git


## Optional requirements for usage:
- for plugin dependencies (`node`, `ctags`, `ranger`, etc), please see the rcfile


## How to install:
From (n)vim, `source` this rcfile, and install plugins using vim plugin manager [`vim-plug`](https://github.com/junegunn/vim-plug)

### On Linux, \*nix, etc:

```shell
mkdir ~/.vimz && git clone --depth 1 https://github.com/junegunn/vim-plug ~/.vimz/autoload && cp -v _vimrc ~/.vimz/ && echo 'source ~/.vimz/_vimrc' >> ~/.vimrc
```

See comments inside the rcfile.

