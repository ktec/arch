# simple dotfiles

## Overview

These dotfiles are designed differently to most.

The strategy means your `~` directory is actually a git repo, and you ignore EVERYTHING EXCEPT the files you want git to manage. Checkout the `.gitingore` file for details. This strategy works extremely well for me, but might not suit everyone. Please investigate careful before choosing this approach for your own system.

## Contents

For the most part, I like to keep things as SIMPLE AS POSSIBLE. Some inspiration taken from here:

https://gist.github.com/kevinelliott/3135044


Use asdf for managing versions

## Usage

I'm testing various strategies at the moment. Previously I have been working in master but now I maintain a local working branch called 'w' and submit PR's to master when I make changes.

## Installation

Getting this on your machine is still wip, however something like this worked for me:

```
git clone --bare $URL .git
git config core.bare false
git fetch -p
git reset --hard
```

I'm not sure we need all these commands, but its a tough one to test until I have virtual machines up and running to test this properly.

Some other stuff:

```
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Then open `vim` and type `:VundleInstall`
