#!/usr/bin/env python3
# coding=utf-8

import os
import re
import subprocess
import time
from pathlib import Path
from io import StringIO

### tweak areas BEGIN ###
# the plugins order matters:
g_use_ohmyzsh_builtin_plugins = [
    'colored-man-pages',
    'docker',
]
g_use_third_party_custom_plugins = [
    f'https://github.com/zsh-users/zsh-autosuggestions.git',
    f'https://github.com/zsh-users/zsh-syntax-highlighting.git',
    f'https://github.com/zsh-users/zsh-history-substring-search.git',
    f'https://github.com/zsh-users/zsh-completions.git',
]
# one of ohmyzsh builtin theme. set `None` to use the default theme
g_use_theme = 'fishy'
# extended config will be append to .zshrc
g_use_extended_cfg = '''
# unalias oh-my-zsh's alias
unalias l la ll lsa
unalias _ - 1 2 3 4 5 6 7 8 9
unalias afind
unalias md rd

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
# some more ls aliases
alias la='ls -a'
alias ll='ls -lh'
'''
### tweak areas END ###


g_env_home = os.environ['HOME']
g_ohmyzsh_dir = os.path.join(g_env_home, '.oh-my-zsh') if ('ZSH' not in os.environ) else os.environ['ZSH']
g_ohmyzsh_zshrc_template = os.path.join(g_ohmyzsh_dir, 'templates', 'zshrc.zsh-template')
g_zshrc = os.path.join(g_env_home, '.zshrc')
g_zshrc_backup = f'{g_zshrc}.backup.{time.strftime("%Y-%m-%d_%H-%M-%S_%Z")}'


def read_current_zshrc_lines():
    """
    read the current ~/.zshrc
    :return:
    """
    if not os.path.exists(g_zshrc):
        return []
    with open(g_zshrc, encoding='utf-8') as fd:
        lines = fd.readlines()
    return lines


def read_ohmyzsh_template_to_zshrc_lines():
    """
    get the original ohmyzsh ~/.zshrc, see setup_zshrc() in ohmyzsh install.sh
    :return:
    """
    with open(g_ohmyzsh_zshrc_template, encoding='utf-8') as fd:
        lines = fd.readlines()
    for i in range(len(lines)):
        if lines[i].startswith('export ZSH='):
            lines[i] = f'export ZSH="{g_ohmyzsh_dir}"\n'  # `sed` command
            break
    return lines


def tweak_zshrc(zshrc_content_lines):
    """
    generate an initial tweaked zshrc file
    :param zshrc_content_lines:
    :return:
    """
    new_content = []

    flag_plugins_end = True  # plugins may in multiple lines
    for line in zshrc_content_lines:

        # plugins: 1. ohmyzsh built-in, 2. third party
        if line.startswith('plugins=') or (not flag_plugins_end):
            if line.find(r')') < 0:  # not found close parenthesis
                flag_plugins_end = False
                continue
            else:
                flag_plugins_end = True
                line = f'''plugins=(
#zsh-history-substring-search should load after zsh-syntax-highlighting
'''
                for plug in g_use_ohmyzsh_builtin_plugins:
                    line += f' {plug}\n'
                for url in g_use_third_party_custom_plugins:
                    line += f' {_repo_dir_from_git_url(url)}\n'
                line += ')\n'

        # theme:
        if line.startswith('ZSH_THEME='):
            if g_use_theme is not None:
                line = f'ZSH_THEME="{g_use_theme}"\n'

        new_content.append(line)

    new_content.append(f'\n{g_use_extended_cfg}')
    if new_content[-1][-1] != '\n':  # the last character
        new_content.append('\n')
    return new_content


def check_if_zshrc_changed(new_zshrc_content):
    """
    compare contents of two files
    :param new_zshrc_content:
    :return: True if contents not equal, False otherwise
    """
    old_content = read_current_zshrc_lines()
    f_old = StringIO()
    f_new = StringIO()
    f_old.write(''.join(old_content))
    f_new.write(''.join(new_zshrc_content))
    return f_old.getvalue().strip() != f_new.getvalue().strip()


def save_strlist_to_file(content_list, filename):
    """
    save string list to file
    :param content_list:
    :param filename:
    :return:
    """
    with open(filename, mode='w+', encoding='utf-8') as fd:
        fd.write(''.join(content_list))
        if content_list[-1][-1] != '\n':  # the last character
            fd.write('\n')


def _repo_dir_from_git_url(url):
    name = Path(url).name
    # m = re.match(r"(.*)(\.[^.]*)", name)
    m = re.match(r"(.*)(\.git)", name)
    d = m.group(1) if m else name
    return d


def git_clone_or_pull(url_list):
    def _run_cmd(cmd):
        subprocess.run(cmd, shell=True, check=True)

    oldpwd = os.getcwd()
    custom_plugins_dir = os.path.join(g_ohmyzsh_dir, 'custom', 'plugins')  # ohmyzsh custom/plugins
    os.chdir(custom_plugins_dir)
    for url in url_list:
        plugin_dir = _repo_dir_from_git_url(url)
        if os.path.exists(plugin_dir):
            print(f'updating {url}')
            _run_cmd(f'cd {plugin_dir} && git pull')
        else:
            _run_cmd(f'git clone --depth 1 {url}')
            print(f'{plugin_dir} cloned.')
    os.chdir(oldpwd)


def main():
    new_zshrc_content = read_ohmyzsh_template_to_zshrc_lines()
    new_zshrc_content = tweak_zshrc(new_zshrc_content)

    if check_if_zshrc_changed(new_zshrc_content):
        print('Step 1: Process rc file')
        if os.path.exists(g_zshrc):
            os.rename(g_zshrc, g_zshrc_backup)
            print(f'backup {g_zshrc} as {g_zshrc_backup}')
        else:
            print(f'{g_zshrc} not exist')
        save_strlist_to_file(new_zshrc_content, g_zshrc)
        print(f'{g_zshrc} re-generated')
    else:
        print(f'Step 1: {g_zshrc} not changed, nothing to do')
    print('Step 2: Manipulate custom plugins')
    git_clone_or_pull(g_use_third_party_custom_plugins)


if __name__ == '__main__':
    main()
