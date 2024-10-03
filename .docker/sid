FROM debian:sid-slim

ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=jgmize
ARG KUBECTL_VERSION="v1.25.16"
ARG KUSTOMIZE_VERSION="v4.5.7"
ARG ARGO_VERSION="v3.5.2"
ARG SOPS_VERSION="v3.8.1"
ARG YQ_VERSION="v4.40.5"
RUN apt-get update && apt-get install -y --no-install-recommends \
    black build-essential ca-certificates curl emacs-nox git gpg gpg-agent htop \
    jq libsqlite3-0 microsocks neovim openssh-server pandoc postgresql-client \
    pre-commit python3-epc python3-importmagic python3-poetry ripgrep sbcl \
    software-properties-common sudo tmux tree tzdata unzip && apt-get clean -y \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get clean -y && \
    rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh && \
    curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar xzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin
RUN curl -sLO https://github.com/argoproj/argo-workflows/releases/download/${ARGO_VERSION}/argo-linux-amd64.gz && \
    gunzip argo-linux-amd64.gz && chmod +x argo-linux-amd64 && \
    mv ./argo-linux-amd64 /usr/local/bin/argo
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws
RUN curl -L "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64" \
    -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops
RUN curl -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -m -s /usr/bin/bash -G sudo ${USERNAME}
RUN chown -R ${USERNAME} /home/linuxbrew/.linuxbrew
WORKDIR /home/${USERNAME}
USER ${USERNAME}
RUN /home/linuxbrew/.linuxbrew/bin/brew install glab nushell
COPY . ./dotfiles
RUN dotfiles/install
# repeat emacs runs to handle packages that intermittently fail to install the first run
RUN for x in 1 2; do emacs -nw -batch -u "${UNAME}" -q -kill ; done
