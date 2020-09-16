#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
fi

# local version of code comes before .vscode-server version in $PATH
alias code=$(which -a code | grep .vscode-server || which code)