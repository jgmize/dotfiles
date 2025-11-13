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

if [ -d ~/dotfiles/.bash_functions.d ]; then
    for f in ~/dotfiles/.bash_functions.d/*; do
        source $f
    done
fi

if [ -z "${SSH_AUTH_SOCK}" ]; then
    $(ssh-auth-sock)
fi

export EDITOR="emacsclient"


if [ "$(which pyenv 2> /dev/null)" ]; then
    eval "$(pyenv init -)"
fi

if [ -f "/google/devshell/bashrc.google" ]; then
    source "/google/devshell/bashrc.google"
fi

for bash_completion in {/opt/homebrew,}/etc/bash_completion; do
    if [ -f ${bash_completion} ] && ! shopt -oq posix; then
        . ${bash_completion}
        break
    fi
done

if [ -d $HOME/google-cloud-sdk ]; then
    source $HOME/google-cloud-sdk/path.bash.inc
    source $HOME/google-cloud-sdk/completion.bash.inc
elif [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
fi

if [ "$(which kubectl 2> /dev/null)" ]; then
    source <(kubectl completion bash)
    if [[ -d ~/.krew/bin ]]; then
        PATH=${PATH}:${HOME}/.krew/bin
    fi
fi

if [ "$(which aws_completer 2> /dev/null)" ]; then
    complete -C $(which aws_completer) aws
fi

if [[ -e /tmp/docker.sock ]]; then
    # created by gcloud-shell in ~/dotfiles/.bash_functions.d/gcloud
    export DOCKER_HOST=unix:///tmp/docker.sock
fi

if [[ -d ~/.vscode-server/bin ]]; then
    for d in $(ls -t ~/.vscode-server/bin); do
        remote_cli=${HOME}/.vscode-server/bin/${d}/bin/remote-cli
        if [[ -e ${remote_cli}/code ]]; then
            PATH=${PATH}:${remote_cli}
            break
        fi
    done
fi

if [[ -d ~/.local/bin ]]; then
    PATH=${HOME}/.local/bin:${PATH}
fi

# dedupe path
PATH=$(printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

export BASH_SILENCE_DEPRECATION_WARNING=1

if [[ -e /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
   alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi
