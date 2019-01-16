#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

CONTAINERS="$(docker container ls -f name="jenkins-with-docker_*" -qa)"

test -n "$CONTAINERS" && docker stop "$CONTAINERS"
test -n "$CONTAINERS" && docker rm "$CONTAINERS" 2>&1 1>/dev/null
