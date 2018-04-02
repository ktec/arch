# =============================================================== #
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Keith Salisbury
# =============================================================== #

# source in some utility files
source $HOME/.colours
source $HOME/.aliases
source $HOME/.functions # includes git_prompt

export EDITOR='vim'

# set history and size to unlimited, but ignore duplicates, ensure write on terminal close
# Note that you don't need to, and indeed should not, export HISTIGNORE.
# This is a bash internal variable, not an environment variable
HISTCONTROL=erasedups
HISTSIZE=
HISTFILESIZE=
# HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:mount:umount:[ \t]*"
# HISTIGNORE=$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])' # ignore single word commands

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Keychain
eval `keychain --eval -q --agents ssh id_ed25519`
