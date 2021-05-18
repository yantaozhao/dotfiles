# tweak `ohmyzsh`

## Dependency

已经安装 [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh), 默认是在`~/.oh-my-zsh`目录。


## 调整方法：

### 手动

1, 三方plugin

```shell
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zdharma/fast-syntax-highlighting.git  (语法高亮可有可无)
```

然后修改`~/.zshrc`插件部分：
```
#plugins=(git)
plugins=(
  colored-man-pages
  zsh-navigation-tools
  zsh-autosuggestions
  fast-syntax-highlighting
)
```

2, 修改`~/.zshrc`一些alias

```
# unalias oh-my-zsh's alias
unalias l la ll lsa
unalias _ - 1 2 3 4 5 6 7 8 9
unalias afind
unalias md rd
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    unalias ls
    alias ls='ls --color=auto'
fi
# some more ls aliases
alias la='ls -a'
alias ll='ls -alh'
```

3, 修改theme
```
#ZSH_THEME="robbyrussell"
ZSH_THEME="simple"
```


### 或脚本

After [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) installed, run the python script to tweak ohmyzsh rcfile.
