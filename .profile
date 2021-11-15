# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -d "$HOME/anaconda/bin" ] ; then
    PATH="$HOME/anaconda/bin:$PATH"
fi

if [ -d $HOME/go ]; then
    export GOROOT=$HOME/go
elif [ -d /usr/local/go ]; then
    export GOROOT=/usr/local/go
fi

if [ ! -z "$GOROOT" ]; then
    export PATH=$PATH:$GOROOT/bin
    export GOPATH=$HOME
elif [ -d /data/data/com.termux/files/usr/lib/go ]; then
    export GOROOT=/data/data/com.termux/files/usr/lib/go
    export GOPATH=$HOME
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "/usr/local/opt/texinfo/bin" ] ; then
    PATH="/usr/local/opt/texinfo/bin:$PATH"
fi

if [[ -e  /opt/homebrew/bin/brew ]]; then
   eval "$(/opt/homebrew/bin/brew shellenv)"
   if [[ -e /opt/homebrew/opt/python@3.10/bin ]]; then
     PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
   fi
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	      . "$HOME/.bashrc"
    fi
fi
