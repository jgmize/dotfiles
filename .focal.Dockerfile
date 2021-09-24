FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl emacs-nox git gpg gpg-agent htop \
    software-properties-common sudo tmate tmux
RUN v=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
    release=https://storage.googleapis.com/kubernetes-release/release \
    helm=https://raw.githubusercontent.com/helm/helm \
    curl -LO "$release/$v/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh $helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh
WORKDIR /root
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
