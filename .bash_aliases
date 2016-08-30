#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
fi

if [ -d ~/dotfiles/.bash_functions.d ]; then
    for f in ~/dotfiles/.bash_functions.d/*; do
        source $f
    done
fi
