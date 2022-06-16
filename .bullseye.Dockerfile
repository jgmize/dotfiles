FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl emacs-nox git gpg gpg-agent htop jq \
    pandoc python3-epc python3-importmagic ripgrep software-properties-common \
    sudo tmate tmux \
    && apt-get clean -y \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV KUBECTL_VERSION=v1.20.0
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh && \
    curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64 -o /usr/local/bin/kustomize && chmod a+x /usr/local/bin/kustomize

WORKDIR /root
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
