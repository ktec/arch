# =============================================================== #
#
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Keith Salisbury
#
# Last modified: Wed Mar 27 14:43:47 GMT 2016
# =============================================================== #

# inspiration:
# https://github.com/mathiasbynens/dotfiles

export EDITOR='vim'

#============================================================
#
#  PATH
#
#============================================================

export PATH="./bin" # ALWAYS use local bins first!!!

export PATH="$PATH:$HOME/.asdf/bin"
export PATH="$PATH:$HOME/.asdf/shims"
export PATH="$PATH:$HOME/Library/Haskell/bin"
export PATH="$PATH:$HOME/.gems/ruby/2.3.1/bin"
# export GOPATH="$HOME/code/go/"
# export PATH=$PATH:$GOPATH/bin

export PATH="$PATH:/usr/local/heroku/bin" ### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/share/npm/bin" # Make Grunt cli work!???

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:/opt/X11/bin"


# asdf provides multiple versions of elixir...
$HOME/.asdf/completions/asdf.bash

# brew install bash-completion
source $(brew --prefix)/etc/bash_completion
source ~/.git-completion.bash

#============================================================
#
#  HISTORY
#
#============================================================

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

#============================================================
#
#  EXTERNAL SOURCES
#
#============================================================

# source in some utility files
source $HOME/.colours
source $HOME/.aliases
source $HOME/.functions # includes git_prompt
source $HOME/.travis/travis.sh # added by travis gem
source $HOME/.chruby


#============================================================
#
#  PROMPT
#
#============================================================

PROMPT_COMMAND="find_git_branch; find_git_dirty; clean_history; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
# export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
export PS1="\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
