# =============================================================== #
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Keith Salisbury
# =============================================================== #

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
[[ $- != *i* ]] && return

# source in some utility files
[[ -f ~/.colours ]] && . ~/.colours
[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f ~/.functions ]] && . ~/.functions

export EDITOR='vim'
export VISUAL="vim"

# HISTORY
# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# HISTCONTROL=erasedups
# set history and size to unlimited, but ignore duplicates, ensure write on terminal close
HISTSIZE=
HISTFILESIZE=

# Note that you don't need to, and indeed should not, export HISTIGNORE.
# This is a bash internal variable, not an environment variable
# HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:mount:umount:[ \t]*"
# HISTIGNORE=$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])' # ignore single word commands

# append to the history file, don't overwrite it
shopt -s histappend

# PROMPT
PROMPT_COMMAND="find_git_branch; clean_history;"
export PS1="[\u@\h \W\$git_branch]$ "

# PATH
# asdf provides multiple versions of elixir, ruby, haskell, elm, etc
$HOME/.asdf/asdf.sh
$HOME/.asdf/completions/asdf.bash

# SSH
# Keychain - not sure this is the best approach...
# eval `keychain --eval -q --agents ssh id_*`
# Some useful info here: https://wiki.archlinux.org/index.php/GNOME/Keyring
# I have implemented suggested update "Using the keyring outside GNOME"
# "PAM method" which updates /etc/pam.d/login
if [ -z "$SSH_ATH_SOCK" ]; then
    eval $(ssh-agent)
    ssh-add
fi
