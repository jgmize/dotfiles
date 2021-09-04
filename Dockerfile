FROM jupyter/minimal-notebook

USER root
RUN apt-get update && apt-get install -y --no-install-recommends emacs-nox tmux
USER jovyan
COPY . ./dotfiles
RUN dotfiles/install
RUN emacs -nw -batch -u "${UNAME}" -q -kill
