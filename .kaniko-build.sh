#!/bin/bash -ex

: ${dockerfile:=${1:-Dockerfile}}
: ${contextdir:=${CI_PROJECT_DIR:=.}}
: ${image:=${2:-${CI_REGISTRY_IMAGE:=jgmize/dotfiles}}}
: ${tag:=${3:-${CI_COMMIT_SHORT_SHA:=$(git rev-parse --short HEAD)}}}

mkdir -p /kaniko/.docker
echo "{\"auths\":{\"$CI_REGISTRY\":{\"auth\":\"$(echo -n ${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD} | base64)\"}}}" > /kaniko/.docker/config.json
/kaniko/executor --context $contextdir --dockerfile $contextdir/$dockerfile --destination $image:$tag
