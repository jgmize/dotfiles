FROM debian:bookworm-slim

ARG USERNAME=jgmize
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl emacs-nox git gpg gpg-agent htop jq \
    libsqlite3-0 microsocks openssh-server pandoc postgresql-client python3-epc \
    python3-importmagic ripgrep software-properties-common sudo tmate tmux tree \
    tzdata unzip && apt-get clean -y \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -LO "https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh && \
    curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v4.4.1/kustomize_v4.4.1_linux_amd64.tar.gz && \
    tar xzf kustomize_v4.4.1_linux_amd64.tar.gz -C /usr/local/bin
RUN curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.3.10/argo-linux-amd64.gz && \
    gunzip argo-linux-amd64.gz && chmod +x argo-linux-amd64 && \
    mv ./argo-linux-amd64 /usr/local/bin/argo
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws
RUN curl -L "https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64" -o "sops" \
    && chmod +x sops \
    && mv sops /usr/local/bin/
RUN curl -L https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_linux_amd64 \
    -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN brew install glab
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -m -s /usr/bin/bash -G sudo ${USERNAME}
WORKDIR /home/${USERNAME}
USER ${USERNAME}
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
