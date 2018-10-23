#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

read -p "Would you like to setup a new SSH key [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd && mkdir .ssh && chmod 700 .ssh
    ssh-keygen -t ed25519
    eval "$(ssh-agent -s)"
    ssh-add
fi

read -p "Would you like to install ktec dotfiles [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Setting up dotfiles. This should move to a dotfiles.git repo..."
    git clone -b arch --bare https://github.com/ktec/dotfiles.git .git
    git config core.bare false
    git remote remove origin
    git remote add -f origin https://github.com/ktec/dotfiles.git
    git fetch -p && git reset --hard origin/arch
fi

read -p "Would you like to install asdf [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
fi

read -p "Would you like to install postgres [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm postgresql
    systemctl enable postgresql.service
    sudo -u postgres initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
    systemctl start postgresql.service
    echo
    echo "Now you can set up a postgres user:"
    echo
    sudo -u postgres createuser --interactive
fi

read -p "Would you like to install dependencies for erlang? [y/N]? " -n 1
echo
    export KERL_CONFIGURE_OPTIONS="--enable-compat28"
    asdf install erlang 21.1.1
fi
