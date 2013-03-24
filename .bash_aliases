#!/bin/bash

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
la() { ls -a; }
lal() { ls -al; }
ll() { ls -al; }
l.() { ls -d .*; }
q() { exit; }
:q() { exit; }
ZZ() { exit; }
sdr() { screen -D -RR; }
sx() { screen -x || screen -q; }
ta() { tmux attach || tmux; }
rscp() { rsync --progress -r --rsh=ssh $1 $2; }
gdr() { sudo killall -SIGHUP gunicorn_django; }
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
elif [ -n $TMUX ]; then
    man() { tmux new-window -n "man $1" "man $1"; }
    root() { tmux new-window -n root "sudo bash -l"; }
    svi() { tmux new-window -n $1 "sudo vim $1"; }
    if [ -n "$DISPLAY" ]; then
        vi() { 
            VIMSERVER=`vim --serverlist`
            if [ "$VIMSERVER" == "GVIM" ]; then
                gvim --remote-tab $1
            elif [ -n "${VIMSERVER:+x}" ]; then
                vim --remote-tab $1
                tmux select-window -t vim
            else
                tmux new-window -n vim "vim --servername vim $1 $2 $3"
            fi
        }
    else
        vi() { tmux new-window -n vim "vim $1 $2 $3 $4 $5 $6"; }
    fi
fi
hgstvi() { for f in `hg st -qn`; do vi $f; done; }
