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
#  EXTERNAL SOURCES
#
#============================================================

# source in some utility files
source $HOME/.colours
source $HOME/.aliases
source $HOME/.travis/travis.sh # added by travis gem
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

#============================================================
#
#  PATH
#
#============================================================

export PATH="./bin:/usr/local/bin:/usr/local/sbin"
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:/opt/X11/bin"
export PATH="$PATH:/usr/local/heroku/bin" ### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/share/npm/bin" # Make Grunt cli work!???
export GOPATH="$HOME/code/go/"
# export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:$HOME/Library/Haskell/bin"

# brew install bash-completion
source $(brew --prefix)/etc/bash_completion

# ...
# . $HOME/.asdf/asdf.sh ### this provides multiple versions of elixir...

#============================================================
#
#  PROMPT
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

clean_history() {
  local exit_status=$?
  # If the exit status was 127, the command was not found. Let's remove it from history
  local number=$(history | tail -n 1 | awk '{print $1}')
  if [ -n "$number" ]; then
      if [ $exit_status -eq 127 ] && ([ -z $HISTLASTENTRY ] || [ $HISTLASTENTRY -lt $number ]); then
          history -d $number
      else
          HISTLASTENTRY=$number
      fi
  fi
}

find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; clean_history; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
#export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
#export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
