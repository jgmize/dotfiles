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
ed() { docker run -it \
    -v $(pwd):/home/spacemacs/src \
    -v $HOME/.ssh:/home/spacemacs/.ssh \
    -v $HOME/.gitconfig:/home/spacemacs/.gitconfig \
    quay.io/jgmize/spacemacs-tmux $@; }
dstop() { docker ps --format={{.ID}} | xargs docker stop; }
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
deis-use() { DEIS_PROFILE=use deis2 "$@"; }
deis-euw() { DEIS_PROFILE=euw deis "$@"; }
deis-euw-dev() { DEIS_PROFILE=euw-dev deis "$@"; }
deis-both() {
    for profile in usw euw; do
        echo $profile
        DEIS_PROFILE=$profile deis "$@";
    done
}
synair() {
    killall -9 synergys
    sleep 1
    synergys
    autossh -R 24800:localhost:24800 air.local 'killall synergyc; sleep 1; /usr/local/bin/synergyc -f localhost'
}
synx1c() {
    ssh -R 24800:localhost:24800 x1c.local 'killall synergyc; sleep 1; synergyc -f localhost'
}
moby() { screen $HOME/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty; }

# from http://www.charliedrage.com/kubernetes-dev-in-one-command
dev_k8s(){
  local choice=$1
  K8S_VERSION=1.2.4

  if [ -z "$(which kubectl)" ]; then
    echo "No kubectl bin exists! Install the bin to continue :)."
    return 1
  fi

  if [[ $choice == "up" ]]; then
    echo "-----Launching local k8s cluster-----"
    docker run \
      --volume=/:/rootfs:ro \
      --volume=/sys:/sys:ro \
      --volume=/var/lib/docker/:/var/lib/docker:rw \
      --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
      --volume=/var/run:/var/run:rw \
      --net=host \
      --pid=host \
      --privileged=true \
      --name=kubelet \
      -d \
      gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION} \
      /hyperkube kubelet \
      --containerized \
      --hostname-override="127.0.0.1" \
      --address="0.0.0.0" \
      --api-servers=http://localhost:8080 \
      --config=/etc/kubernetes/manifests \
      --cluster-dns=10.0.0.10 \
      --cluster-domain=cluster.local \
      --allow-privileged=true --v=2

    echo "-----Waiting for k8s to initialize-----"
    until curl 127.0.0.1:8080 &>/dev/null;
    do
      echo ...
      sleep 1
    done
    echo "-----Launched!-----"

    echo "-----Setting local dev variables-----"
    kubectl config set-cluster dev --server=http://localhost:8080
    kubectl config set-context dev --cluster=dev --user=default
    kubectl config use-context dev
    kubectl config set-credentials default --token=foobar

    echo "-----Create the kube-system namespace-----"
    kubectl create namespace kube-system

    echo "-----Ready for development!-----"

  elif [[ $choice == "down" ]]; then
    echo "-----Removing all namespaces-----"
    kubectl delete --all namespaces

    echo "-----Remove EVERYTHINGGGG-----"
    kubectl get pvc,pv,svc,rc,po --all-namespaces | grep -v 'k8s-\|NAME\|CONTROLLER\|kubernetes' | awk '{print $2}' | xargs --no-run-if-empty kubectl delete pvc,pv,svc,rc,po 2>/dev/null

    echo "-----Waiting for everything to terminate-----"
    kubectl get po,svc,rc --all-namespaces
    sleep 3 # give kubectl chance to catch up to api call
    while [ 1 ]
    do
      k8s=`kubectl get po,svc,rc --all-namespaces | grep Terminating`
      if [[ $k8s == "" ]]
      then
        break
      else
        echo "..."
      fi
      sleep 1
    done

    # Run twice due to issue with aufs debian driver
    echo "-----Removing all k8s containers-----"

    # Remove the initial kubelet
    docker rm -f kubelet

    for run in {0..2}
    do
      docker ps -a | grep 'k8s_' | awk '{print $1}' | xargs --no-run-if-empty docker rm -f
      docker ps -a | grep 'gcr.io/google_containers/hyperkube-amd64' | awk '{print $1}' | xargs --no-run-if-empty docker rm -f
    done

    rm ~/.kube/config

  elif [[ $choice == "clean" ]]; then
    echo "-----Cleaning / removing all pods and containers from default namespace-----"
    kubectl get pvc,pv,svc,rc,po | grep -v 'k8s-\|NAME\|CONTROLLER\|kubernetes' | awk '{print $1}' | xargs --no-run-if-empty kubectl delete pvc,pv,svc,rc,po 2>/dev/null

    echo "-----Waiting for everything to terminate-----"
    kubectl get po,svc,rc
    sleep 3 # give kubectl chance to catch up to api call
    while [ 1 ];
    do
      k8s=`kubectl get po,svc,rc | grep Terminating`
      if [[ $k8s == "" ]]; then
        break
      else
        echo "..."
      fi
      sleep 1
    done

  elif [[ $choice == "gui" ]]; then
    kubectl create -f "https://raw.githubusercontent.com/kubernetes/kubernetes/release-1.2/cluster/addons/dashboard/dashboard-controller.yaml" --namespace=kube-system
    kubectl create -f "https://raw.githubusercontent.com/kubernetes/kubernetes/release-1.2/cluster/addons/dashboard/dashboard-service.yaml" --namespace=kube-system

  elif [[ $choice == "dns" ]]; then
    # Set the amount of dns replicas and env variables
    export DNS_REPLICAS=1
    export DNS_DOMAIN=cluster.local
    export DNS_SERVER_IP=10.0.0.10

    # Grab the official dns yaml file
    wget http://kubernetes.io/docs/getting-started-guides/docker-multinode/skydns.yaml.in -O skydns.yaml.in
    sed -e "s/{{ pillar\['dns_replicas'\] }}/${DNS_REPLICAS}/g;s/{{ pillar\['dns_domain'\] }}/${DNS_DOMAIN}/g;s/{{ pillar\['dns_server'\] }}/${DNS_SERVER_IP}/g" skydns.yaml.in > ./skydns.yaml


    # Because of https://github.com/kubernetes/kubernetes/issues/23474
    #dns="\ \ \ \ \ \ \ \ - -nameservers=8.8.8.8:53"
    #sed -i "73i$dns" skydns.yaml

    # Deploy!
    kubectl get ns
    kubectl create -f ./skydns.yaml
    rm skydns.yaml*

  elif [[ $choice == "restart" ]]; then
    dev_k8s down
    dev_k8s up

  elif [[ $choice == "pv" ]]; then
    mkdir -p /tmp/foobar
    cat <<EOF | kubectl create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: foobar
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  hostPath:
    path: /tmp/foobar
EOF

  else
    echo "Kubernetes dev environment"
    echo "Usage: "
    echo " dev_k8s {up|down|restart|clean|gui|dns|pv}"
    echo "Methods: "
    echo " up"
    echo " down"
    echo " restart"
    echo " clean - returns k8s env to a clean slate"
    echo " gui - ui for k8s at localhost:9090"
    echo " dns - deployment of skydns / name resolution"
    echo " pv - creates a 20Gb persistent volume named foobar at /tmp/foobar"
  fi
}
