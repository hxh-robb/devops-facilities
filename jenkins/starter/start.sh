#!/usr/bin/env bash

SHOW_ADMIN_PASSWD=false
for arg in $@; do
  test "$arg" == "--show-admin-passwd" && SHOW_ADMIN_PASSWD=true
done

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

test -x stop.sh && ./stop.sh

PORT1="${1:-8080}"
PORT2="${2:-50000}"
TIMESTAMP="$(date -u +%Y%m%d%H%M%S)"
NAME="jenkins-with-docker_$TIMESTAMP"

mkdir -p .ssh
test -f .ssh/id_rsa || ssh-keygen -t rsa -b 4096 -N "" -f .ssh/id_rsa > /dev/null
test -f .ssh/config || cat >.ssh/config <<EOT
Host *
    StrictHostKeyChecking no
EOT

test ! -d .docker && (test -n "$(ls init.tar.gz* 2>/dev/null)" && cat init.tar.gz* | tar -xz -f -)
test -d .docker && (test -n "$(ls jobs.tar.gz* 2>/dev/null)" && cat jobs.tar.gz* | tar -xz -f -)

#  -v "$(pwd)/jenkins.id_rsa:/root/.ssh/id_rsa" \
#  -v "$(pwd)/ssh.config:/root/.ssh/config" \
#  --rm \
docker run --name "$NAME" -d \
  -p "$PORT1:8080" \
  -p "$PORT2:50000" \
  -v "$(pwd)/.docker:/var/jenkins_home" \
  -v "$(pwd)/.m2:/root/.m2" \
  -v "$(pwd)/.ssh:/root/.ssh" \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  --restart=unless-stopped \
  robbtsang/jenkins-with-docker:latest

docker exec "$NAME" chown 0:0 -R /root
test "$SHOW_ADMIN_PASSWD" == "true" && cat .docker/secrets/initial*
