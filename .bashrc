# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
if [ -z "$PS1" ]; then
  return
fi

if [[ $- != *i* ]] ; then
    return
fi

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    if [ -n "$SHORTHOST" ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@$SHORTHOST\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\H:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
elif [ -f ~/dotfiles/.bash_aliases ]; then
    . ~/dotfiles/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR="emacsclient"

if [ -d $HOME/google-cloud-sdk ]; then
    source $HOME/google-cloud-sdk/path.bash.inc
    source $HOME/google-cloud-sdk/completion.bash.inc
fi

if [ "$(which pyenv 2> /dev/null)" ]; then
    eval "$(pyenv init -)"
fi

if [ -f "/google/devshell/bashrc.google" ]; then
    source "/google/devshell/bashrc.google"
fi

if [ "$(which kubectl 2> /dev/null)" ]; then
    source <(kubectl completion bash)
fi

if [ "$(which aws_completer 2> /dev/null)" ]; then
    complete -C $(which aws_completer) aws
fi

if [[ -e $HOME/Library/Python/3.7/bin ]]; then
    PATH=$PATH:$HOME/Library/Python/3.7/bin
fi

if [[ -e /usr/local/opt/grep/libexec/gnubin ]]; then
    PATH=/usr/local/opt/grep/libexec/gnubin:$PATH
fi

# dedupe path
PATH=$(printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')
