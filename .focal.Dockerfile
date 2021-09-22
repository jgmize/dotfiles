FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl emacs-nox git htop tmate tmux
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh
WORKDIR /root
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
