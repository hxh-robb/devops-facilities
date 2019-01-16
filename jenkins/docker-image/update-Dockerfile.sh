#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

type wget >/dev/null && wget -O Dockerfile https://raw.githubusercontent.com/getintodevops/jenkins-withdocker/master/Dockerfile

# Used for remote set-up
echo 'RUN apt-get -y install sshpass' >> Dockerfile
