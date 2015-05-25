
# set history and size to unlimited, but ignore duplicates
export HISTCONTROL=erasedups
export HISTSIZE=
export HISTFILESIZE=

# source chruby to enable changing ruby versions
if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh # chruby will check the current and parent directories for a .ruby-version file
else
  echo "Ain't got no chruby"
fi

