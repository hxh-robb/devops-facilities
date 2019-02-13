#!/usr/bin/env bash

SEPARATE=false
for arg in $@; do
  test "$arg" == "--separate" && SEPARATE=true
done

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd "$DIR"

test $(docker ps -f name="jenkins-with-docker_*"|wc -l) -ge 2 && NEED_START=true || NEED_START=false

test "$NEED_START" == "true" && test -x stop.sh && ./stop.sh

TIMESTAMP="$(date -u +%Y%m%d%H%M%S)"

#BACKUP_FILE=$(test "$JOB_ONLY" == "true" && echo "jobs.${TIMESTAMP}.tar.gz" || echo "full.${TIMESTAMP}.tar.gz")
#test -f "$BACKUP_FILE" && rm -f "$BACKUP_FILE"
#test "$JOB_ONLY" == "true" && \
#  (test -d .docker && test -d .m2 && sudo tar --exclude=".docker/jobs/*/builds/*" -czv -f "$BACKUP_FILE" .docker/jobs .docker/plugins) || \
#  (test -d .docker && test -d .m2 && sudo tar --exclude=".docker/logs" --exclude=".docker/war" --exclude=".docker/workspace" --exclude=".docker/jobs/*/builds/*" -czv -f "$BACKUP_FILE" .docker .m2 .ssh)
#test -f "$BACKUP_FILE" && mkdir -p .backup
#test -f "$BACKUP_FILE" && mv "$BACKUP_FILE" .backup/

SUFFIX="${TIMESTAMP}.tar.gz"
FULL_TAR="full.${SUFFIX}"
INIT_TAR="init.${SUFFIX}"
PLUGINS_TAR="plugins.${SUFFIX}"
JOBS_TAR="jobs.${SUFFIX}"

if [ "${SEPARATE}" == "true" ]; then
  test -d .docker && sudo tar --exclude=".docker/war" --exclude=".docker/workspace" --exclude=".docker/jobs" --exclude=".docker/plugins" --exclude=".docker/logs" -czv -f "$INIT_TAR" .docker
  test -d .docker && sudo tar -czv -f "$PLUGINS_TAR" .docker/plugins
  test -d .docker && sudo tar --exclude=".docker/jobs/*/builds/*" -czv -f "$JOBS_TAR" .docker/jobs
else
  (\
    test -d .docker && \
    test -d .m2 && \
    test -d .ssh && \
    sudo tar --exclude=".docker/logs" --exclude=".docker/war" --exclude=".docker/workspace" --exclude=".docker/jobs/*/builds/*" -czv -f "$FULL_TAR" \
    .docker .m2 .ssh \
  )
fi

(test -f "${FULL_TAR}" || test -f "${INIT_TAR}" || test -f "${PLUGINS_TAR}" || test -f "${JOBS_TAR}" ) && mkdir -p .backup
test -f "$FULL_TAR" && mv "$FULL_TAR" .backup/
test -f "$INIT_TAR" && mv "$INIT_TAR" .backup/
test -f "$PLUGINS_TAR" && mv "$PLUGINS_TAR" .backup/
test -f "$JOBS_TAR" && mv "$JOBS_TAR" .backup/


test "$NEED_START" == "true" && test -x start.sh && ./start.sh
