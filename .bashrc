# =============================================================== #
#
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Keith Salisbury
#
# Last modified: Wed Mar 27 14:43:47 GMT 2016
# =============================================================== #

# set history and size to unlimited, but ignore duplicates, ensure write on terminal close
# Note that you don't need to, and indeed should not, export HISTIGNORE.
# This is a bash internal variable, not an environment variable
HISTCONTROL=erasedups
HISTSIZE=
HISTFILESIZE=
# HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:mount:umount:[ \t]*"
# HISTIGNORE=$'*([\t ])+([-%+,./0-9\:@A-Z_a-z])*([\t ])' # ignore single word commands
shopt -s histappend
export EDITOR='vim'

#============================================================
#
#  EXTERNAL SOURCES
#
#============================================================

# source in some utility files
[ -f $HOME/.colours ] && source $HOME/.colours
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh # added by travis gem
[ -f $HOME/.bin/tmuxinator.bash ] && source $HOME/.bin/tmuxinator.bash

[ -f /usr/local/share/chruby/chruby.sh ] && source /usr/local/share/chruby/chruby.sh
[ -f /usr/local/share/chruby/auto.sh ] && source /usr/local/share/chruby/auto.sh

#============================================================
#
#  ALIASES AND FUNCTIONS
#
#============================================================

#-------------------
# Personnal Aliases
#-------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i' # -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

alias ..='cd ../'
alias ...='cd ../../'
alias c='clear'
alias vi=vim
alias edit='vim'
alias be='bundle exec '
alias ta='tmux attach -t'
alias tm='tm'
alias ts='tmux ls'
alias pg_start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres stop"
alias pg_restart="pg_ctl -D /usr/local/var/postgres -m i -l /usr/local/var/postgres/server.log restart"

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
# alias ls='ls -h --color'
# alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
# alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
# alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
# alias la='ls -la'
#
# # The ubiquitous 'll': directories first, with alphanumeric sorting:
# alias ll="ls -lv --group-directories-first"
# alias lm='ll |more'        #  Pipe through 'more'
# alias lr='ll -R'           #  Recursive ls.
# alias la='ll -A'           #  Show hidden files.
# alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

#============================================================
#
#  Git
#
#============================================================

# Aliases - http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
alias g='git'
alias gs='git status'
alias gd='git diff'
alias save_game='git add . && git commit -m'
alias new_quest='git checkout -b'
alias publish_game='git push'

alias gbr='for k in `git branch|perl -pe s/^..//`;do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;done|sort -r'
alias git_delete_merged_branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gbgrep="git branch -a | tr -d \* | xargs git grep" # =>  $ git grep_all <regexp>
alias gbd="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative master.."
alias greset='git co master; git fetch -p; git reset --hard origin/master'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias grbm='git fetch -p;git rebase origin/master; git push --force-with-lease'
alias gfr='git fetch -p;git reset --hard origin/master'
alias amend_commit='git add . && git commit --amend -C HEAD'

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

#============================================================
#
#  PROMPT
#
#============================================================

PROMPT_COMMAND="find_git_branch; find_git_dirty; clean_history; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
#export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
export PS1="\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
#export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "

#============================================================
#
#  PATH
#
#============================================================

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
export PATH="/usr/local/heroku/bin:$PATH" ### Added by the Heroku Toolbelt
export PATH="/usr/local/share/npm/bin:$PATH" # Make Grunt cli work!???
export GOPATH="$HOME/code/go/"
# export PATH=$PATH:$GOPATH/bin
export PATH="./bin:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"

# brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# ...
. $HOME/.asdf/asdf.sh
