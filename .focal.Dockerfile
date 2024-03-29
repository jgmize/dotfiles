FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl emacs-nox git gpg gpg-agent htop \
    pandoc python3-epc python3-importmagic ripgrep software-properties-common \
    sudo tmate tmux \
    && apt-get clean -y \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh && \
    curl -LO "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" && bash install_kustomize.sh && mv kustomize /usr/local/bin/

WORKDIR /root
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
