#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
    # local version of code comes before .vscode-server version in $PATH
    alias code=$(which -a code | grep .vscode-server || which code)
fi

if [[ -e ~/.cargo/bin/exa ]]; then
    alias ls=exa
fi
