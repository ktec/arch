# =============================================================== #
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Keith Salisbury
# =============================================================== #

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# source in some utility files
[[ -f ~/.colours ]] && ~/.colours
[[ -f ~/.aliases ]] && . ~/.bash_aliases
[[ -f ~/.aliases ]] && ~/.aliases
[[ -f ~/.functions ]] && ~/.functions

export EDITOR='vim'
export VISUAL="vim"

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

# Keychain - not sure this is the best approach...
# eval `keychain --eval -q --agents ssh id_*`
