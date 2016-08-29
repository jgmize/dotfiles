#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
fi

if [ -f ~/dotfiles/.bash_functions ]; then
    . ~/dotfiles/.bash_functions
fi
