#!/bin/bash -ex

: ${dockerfile:=${1:-Dockerfile}}
: ${contextdir:=${CI_PROJECT_DIR:=.}}
: ${image:=${CI_REGISTRY_IMAGE:=${2:-jgmize/dotfiles}}}
: ${tag:=${CI_COMMIT_TAG:=${3:-latest}}}

mkdir -p /kaniko/.docker
echo "{\"auths\":{\"$CI_REGISTRY\":{\"auth\":\"$(echo -n ${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD} | base64)\"}}}" > /kaniko/.docker/config.json
/kaniko/executor --context $contextdir --dockerfile $contextdir/$dockerfile --destination $image:$tag
