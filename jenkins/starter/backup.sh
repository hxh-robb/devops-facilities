#!/usr/bin/env bash

JOB_ONLY=false
for arg in $@; do
  test "$arg" == "--job-only" && JOB_ONLY=true
done

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

test $(docker ps -f name="jenkins-with-docker_*"|wc -l) -ge 2 && NEED_START=true || NEED_START=false

test "$NEED_START" == "true" && test -x stop.sh && ./stop.sh

TIMESTAMP="$(date -u +%Y%m%d%H%M%S)"
BACKUP_FILE=$(test "$JOB_ONLY" == "true" && echo "jobs.${TIMESTAMP}.tar.gz" || echo "full.${TIMESTAMP}.tar.gz")
test -f "$BACKUP_FILE" && rm -f "$BACKUP_FILE"
test "$JOB_ONLY" == "true" && \
  (test -d .docker && test -d .m2 && sudo tar --exclude=".docker/jobs/*/builds/*" -czv -f "$BACKUP_FILE" .docker/jobs .docker/plugins) || \
  (test -d .docker && test -d .m2 && sudo tar --exclude=".docker/logs" --exclude=".docker/war" --exclude=".docker/workspace" --exclude=".docker/jobs/*/builds/*" -czv -f "$BACKUP_FILE" .docker .m2)
test -f "$BACKUP_FILE" && mkdir -p .backup
test -f "$BACKUP_FILE" && mv "$BACKUP_FILE" .backup/

test "$NEED_START" == "true" && test -x start.sh && ./start.sh
