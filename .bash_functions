#!/bin/bash

..() { cd ..; }
...() { cd ../..; }
....() { cd ../../..; }
.....() { cd ../../../..; }
......() { cd ../../../../..; }
q() { exit; }
:q() { exit; }
ZZ() { exit; }
rscp() { rsync --progress -r --rsh=ssh $1 $2; }
gtdsync() {
    HOST=${1:-x1c.usw}
    RSYNC_ARGS="-av --delete . ${HOST}:gtd/"
    cd ~/gtd;
    echo "syncing gtd to ${HOST} (dry run):";
    rsync -n ${RSYNC_ARGS};
    echo "enter to proceed, Ctrl-c to break";
    read;
    rsync ${RSYNC_ARGS};
}

rsshtun() {
    REMOTE_PORT="${2:-2222}"
    autossh -R $REMOTE_PORT:localhost:22 $1 "
        while true;
           do nc -zv localhost $REMOTE_PORT;
           sleep 2;
        done"; }
rsshtunair() {
    REMOTE_PORT="${2:-2224}"
    BASTION="${1:-ssh.us-west.moz.works}"
    while true; do
    ssh -R $REMOTE_PORT:localhost:22 $BASTION \
        "while true; do nc -zv localhost $REMOTE_PORT; sleep 2; done";
    done; }
caps2esc() { echo keycode 58 = Escape | sudo loadkeys -; }
caps2escx() { xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'; }
e() { emacsclient --no-wait "$@" 2>/dev/null || emacs -nw "$@"; }
et() { emacsclient -t "$@" || emacs -nw "$@"; }

hgstvi() { for f in `hg st -qn`; do vi $f; done; }
mosha() { mosh --server=/usr/local/bin/mosh-server air.local; }
