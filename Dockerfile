FROM jupyter/minimal-notebook

RUN apt-get update && apt-get install -y --no-install-recommends emacs-nox tmux
COPY . ./dotfiles
RUN dotfile/install
RUN emacs -nw -batch -u "${UNAME}" -q -kill
