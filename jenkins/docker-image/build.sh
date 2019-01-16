#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

docker build . -t robbtsang/jenkins-with-docker:latest 
docker push robbtsang/jenkins-with-docker:latest
