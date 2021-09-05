FROM jupyter/minimal-notebook

USER root
RUN apt-get update && apt-get install -y --no-install-recommends curl emacs-nox tmux
USER jovyan
COPY . ./dotfiles
RUN dotfiles/install
RUN emacs -nw -batch -u "${UNAME}" -q -kill
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && ./get_helm.sh
