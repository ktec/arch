if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh # chruby will check the current and parent directories for a .ruby-version file
else
  echo "Ain't got no chruby"
fi

