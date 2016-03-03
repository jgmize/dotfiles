#!/bin/bash

if [ $(uname) == "Darwin" ]; then
    alias ls='ls -G'
fi

..() { cd ..; }
...() { cd ../..; }
....() { cd ../../..; }
.....() { cd ../../../..; }
......() { cd ../../../../..; }
du1() { du -h --max-depth=1; }
du1g() { du1 | grep G; }
du1m() { du1 | grep M; }
du1gs() { du1g | sort -n; }
du1ms() { du1m | sort -n; }
q() { exit; }
:q() { exit; }
ZZ() { exit; }
sdr() { screen -D -RR; }
sx() { screen -x || screen -q; }
ta() { tmux attach || tmux; }
rscp() { rsync --progress -r --rsh=ssh $1 $2; }
rsshtun() {
    REMOTE_PORT="${2:-2222}"
    autossh -R $REMOTE_PORT:localhost:22 $1 "
        while true;
           do nc -zv localhost $REMOTE_PORT;
           sleep 2;
        done"; }
caps2esc() { echo keycode 58 = Escape | sudo loadkeys -; }
caps2escx() { xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'; }
e() { emacsclient --no-wait $@ 2>/dev/null || emacs -nw $@; }
if [ "$STY" != "" ]; then
    man() { screen -t man\ $1 man $1; }
    sping() { screen -t "ping $1" ping $1; }
    svi() { screen -t $1 sudo vim $1; }
    svs() { screen vim -S; }
    root() { screen -t root sudo bash -l; }
    if [ -n "$DISPLAY" ]; then
        vi() { 
            VIMSERVER=`vim --serverlist`
            if [ "$VIMSERVER" == "GVIM" ]; then
                gvim --remote $1
            elif [ -n "${VIMSERVER:+x}" ]; then
                vim --remote $1
            else
                screen vim --servername vim $1 
            fi
        }
        vit() { 
            VIMSERVER=`vim --serverlist`
            if [ "$VIMSERVER" == "GVIM" ]; then
                gvim --remote-tab $1
            elif [ -n "${VIMSERVER:+x}" ]; then
                vim --remote-tab $1
            else
                screen vim --servername vim $1 
            fi
        }
    else
        vi() { screen vim $1 $2 $3 $4 $5 $6; }
    fi
elif [ "$TMUX" ]; then
    man() { tmux new-window -n "man $1" "man $1"; }
    root() { tmux new-window -n root "sudo bash -l"; }
    svi() { tmux new-window -n $1 "sudo vim $1"; }
    vi() { 
        if [ "$DISPLAY" == "" ]; then
            if [ "`ps ax | grep -c /usr/bin/X`" == "2" ]; then
                export DISPLAY=:0
                tmux set-environment DISPLAY :0
            fi
        fi
        if [ "$DISPLAY" ]; then
            VIMSERVER=`vim --serverlist`
            if [ "$VIMSERVER" == "GVIM" ]; then
                gvim --remote $1
            elif [ "$VIMSERVER" ]; then
                TMUXWINDOW=`tmux display-message -p '#W'`
                #if [ $TMUXWINDOW != "bash" -a `vim --serverlist | grep -i $TMUXWINDOW` ]; then
                if [ `vim --serverlist | grep -i $TMUXWINDOW` ]; then
                    vim --servername $TMUXWINDOW --remote $1
                else
                    vim --remote $1
                    tmux select-window -t vim
                fi
            else
                echo "Starting new vimserver"
                tmux new-window -n vim "DISPLAY=$DISPLAY; vim --servername vim $1 $2 $3"
            fi
        else
            tmux new-window -n vim "vim $1 $2 $3 $4 $5 $6"
        fi
    }
    vis() {
        tmux split-window "vim --servername `tmux display-message -p '#W'` $1"
    }
fi
hgstvi() { for f in `hg st -qn`; do vi $f; done; }
nse() { docker exec -it $1 bash; }
deis-usw() { DEIS_PROFILE=usw deis "$@"; }
deis-euw() { DEIS_PROFILE=euw deis "$@"; }
synair() {
    killall -9 synergys
    sleep 1
    synergys
    autossh -R 24800:localhost:24800 air.local 'killall synergyc; sleep 1; /usr/local/bin/synergyc -f localhost'
}
synx1c() {
    ssh -R 24800:localhost:24800 x1c.local 'killall synergyc; sleep 1; synergyc -f localhost'
}
