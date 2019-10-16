#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
fi
