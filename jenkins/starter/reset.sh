#!/usr/bin/env bash
SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

test -x stop.sh && ./stop.sh

sudo rm -rf .backup .docker .ssh .m2
