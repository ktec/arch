# simple dotfiles

## Overview

These dotfiles are managed differently to most.

Why not just put your home directory under git management?

"Because there's just too much stuff, most I don't want managed by git"

Fair enough, thats why the core of this strategy is to "ignore everything except".

Checkout .gitignore and you'll see what I mean.

The advantages of this are that your home directory _is under source control_.

## Contents

I have both Linux and MacOSX devices. To deal with differences, I use branches.

Master branch contains common configurations.

Use asdf for managing versions of stuff like ruby, elixir, haskell

## Usage

## Installation

To install, you need a little git trickery. Clone as a bare repository, then
re-establish the remote connection.

To clone the master branch:
```
cd
git clone --bare https://github.com/ktec/dotfiles.git .git
git config core.bare false
git remote remove origin && git remote add -f origin git@github.com:ktec/dotfiles.git
```


To clone a specific branch:
```
cd
git clone -b arch --bare https://github.com/ktec/dotfiles.git .git
git config core.bare false
git remote remove origin && git remote add -f origin git@github.com:ktec/dotfiles.git
```

This works beautifully for me. Obviously if you want to do this yourself,
you'll need to change things to suit your needs.


## Other stuff

Some other stuff:

```
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Then open `vim` and type `:VundleInstall`
