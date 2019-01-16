#!/usr/bin/env bash
SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"


test $(docker ps -f name="jenkins-with-docker_*"|wc -l) -ge 2 && NEED_START=true || NEED_START=false

test "$NEED_START" == "true" && test -x stop.sh && ./stop.sh

test -f "$1" && sudo tar -zxv -f "$1" -C .

test "$NEED_START" == "true" && test -x start.sh && ./start.sh
