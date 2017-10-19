#
# =============================================================== #
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

# export PATH="./bin" # ALWAYS use local bins first!!!
# export PATH="$PATH:./node_modules/.bin" # npm weirdness!
PATH=""

PATH="$PATH:$HOME/.asdf/bin"
PATH="$PATH:$HOME/.asdf/shims"
PATH="$PATH:$HOME/.yarn/bin"
PATH="$PATH:$HOME/.gems/ruby/2.3.1/bin"
# PATH="$PATH:$HOME/.asdf/installs/node/7.8.0/bin"
# PATH="$PATH:$HOME/Library/Haskell/bin"
# PATH="$PATH:`yarn global bin`"
# GOPATH="$HOME/code/go/"
# PATH=$PATH:$GOPATH/bin

PATH="$PATH:/usr/local/heroku/bin" ### Added by the Heroku Toolbelt
PATH="$PATH:/usr/local/share/npm/bin" # Make Grunt cli work!???

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

PATH="$PATH:/usr/local/bin:/usr/local/sbin"
PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="$PATH:/opt/X11/bin"
PATH="$PATH:/opt/pkg/sbin"
PATH="$PATH:/opt/pkg/bin"

export PATH

# asdf provides multiple versions of elixir...
$HOME/.asdf/asdf.sh
$HOME/.asdf/completions/asdf.bash

# brew install bash-completion
case "$OSTYPE" in
  darwin*) source $(brew --prefix)/etc/bash_completion  ;;
  linux*)   echo "LINUX" ;;
esac
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
# source $HOME/.travis/travis.sh # added by travis gem


#============================================================
#
#  PROMPT
#
#============================================================

# Default Git enabled prompt with dirty state
PROMPT_COMMAND="find_git_branch; find_git_dirty; clean_history;"
# MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{
# if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
# else if (NF>3) print $1 "/" $2 "/.../" $NF;
# else print $1 "/.../" $NF; }
# else print $0;}'"'"')'
# PS1='$(eval "echo ${MYPS}$ \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\] ") '
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
# export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
# export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\] "
export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]▸ "
# PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
