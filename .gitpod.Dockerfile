FROM registry.gitlab.com/jgmize/dotfiles/focal:aefd02c1

# https://github.com/gitpod-io/workspace-images/blob/master/full/Dockerfile
# https://docs.docker.com/engine/install/ubuntu/
RUN curl -o /var/lib/apt/docker.gpg -fsSL https://download.docker.com/linux/ubuntu/gpg \
    && apt-key add /var/lib/apt/docker.gpg \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal containerd.io \
    && apt-get clean -y \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.11/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 \
    && chmod +x /usr/local/bin/docker-compose
