#!/usr/bin/env bash

## operator must be root
test "$USER" == "root" || echo "Super-user root is required"
test "$USER" == "root" || exit 1

SCRIPT=`readlink -f "$0"`
DIR=`dirname "$SCRIPT"`
cd "$DIR"

## setup docker-ce
cmd=`type -t docker` # check docker command exist
if [ -z "$cmd" ]; then
  echo '========== Installing docker-ce =========='
  ## install docker-ce
  yum install -y --cacheonly --disablerepo=* *.rpm
  #usermod -aG docker ${USER}
  ## enbale & start docker
  systemctl enable docker
  systemctl start docker
  echo '======= docker-ce is now installed ======='
  
else
  echo "====== docker is already installed ======="
  docker -v
fi

## setup docker-compose
cmd=$(type -t /usr/local/bin/docker-compose)
if [ -z "$cmd" ]; then
  echo '========== Installing docker-compose =========='
  cp prereq/docker-compose /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo '======= docker-compose is now installed ======='
else
  echo "===== docker-compose is already installed ====="
  docker-compose -v
fi

## /etc/docker/daemon.json
echo "Given reigistry is [$1]"
if [ -n "$1" ]; then
  echo '===== Creating /etc/docker/daemon.json ====='
  test -f "/etc/docker/daemon.json" && mv "/etc/docker/daemon.json" "/etc/docker/daemon.json.bak.$(date +%Y%m%d%H%M%S)"
  echo "{\"insecure-registries\":[\"$1\"]}" | sudo tee "/etc/docker/daemon.json"
  systemctl restart docker.service
  echo '==== /etc/docker/daemon.json is created ===='
fi
