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
export ERL_AFLAGS="-kernel shell_history enabled"
export GDK_SCALE=2

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

# Save current working dir
save_cwd() {
  pwd > ${HOME}/.cwd
}


# PROMPT
PROMPT_COMMAND="find_git_branch; clean_history; save_cwd;"
export PS1="[\u@\h \W\$git_branch]$ "

# Change to saved working dir
[[ -f "${HOME}/.cwd" ]] && cd "$(< ${HOME}/.cwd)"

# PATH

pathmunge () {
    # Remove from path
    [[ ":$PATH:" == *":$1:"* ]] && PATH="${PATH//$1:/}"
    # Now add to path
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
       if [ "$2" = "after" ] ; then
          PATH="$PATH:$1"
       else
          PATH="$1:$PATH"
       fi
    fi
}

# asdf provides multiple versions of elixir, ruby, haskell, elm, etc
[[ -f ~/.asdf/asdf.sh ]] && . ~/.asdf/asdf.sh
[[ -f ~/.asdf/completions/asdf.bash ]] && . ~/.asdf/completions/asdf.bash
[[ -f ~/.git-completion.bash ]] && . ~/.git-completion.bash

pathmunge $HOME/.local/bin
# For elixir development
pathmunge $HOME/code/elixir/elixir/bin
# Add all local bin
pathmunge .bin

# SSH
# Keychain - not sure this is the best approach...
eval `keychain --eval --nogui --noask -q --agents ssh id_*`
# Some useful info here: https://wiki.archlinux.org/index.php/GNOME/Keyring
# I have implemented suggested update "Using the keyring outside GNOME"
# "PAM method" which updates /etc/pam.d/login
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval $(ssh-agent)
#     ssh-add
# fi

# add GPG key to bash profile
export GPG_TTY=$(tty)

# Build erlang docs
export KERL_BUILD_DOCS=yes
