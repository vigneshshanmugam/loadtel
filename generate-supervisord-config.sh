#!/bin/bash -e

if [ -z "${DELAY_START}" ]; then
  echo "expected DELAY_START"
  exit 1
fi

if [ -z "${DURATION}" ]; then
  echo "expected DURATION"
  exit 1
fi

if [ -z "${NUMPROCS}" ]; then
  echo "expected NUMPROCS"
  exit 1
fi

GENERATOR_MODE=${GENERATOR_MODE:-"metrics"}

if [ "${GENERATOR_MODE}" = "all" ] && [ -z "${LOADGEN_DOCKER_IMAGE}" ]; then
  echo "expected LOADGEN_DOCKER_IMAGE when GENERATOR_MODE=all"
  exit 1
fi

if [ "${GENERATOR_MODE}" = "all" ]; then
  OTELCOL_COMMAND="./run-collector.sh docker run --rm -e ITERATION=%(ENV_ITERATION)s -e INSTANCE=%(process_num)d -v %(here)s/config.yaml:/config.yaml:ro ${LOADGEN_DOCKER_IMAGE} --config /config.yaml"
else
  OTELCOL_COMMAND="./run-collector.sh /usr/bin/otelcol-contrib --config config.yaml"
fi

cat > supervisord.ini << EOF
[program:otelcol]
command=${OTELCOL_COMMAND}
environment=INSTANCE=%(process_num)d,DURATION=${DURATION},DELAY_START=${DELAY_START}
numprocs=${NUMPROCS}
process_name=%(program_name)s-%(process_num)d
stdout_logfile=%(here)s/logs/%(program_name)s-%(process_num)d.log
stderr_logfile=%(here)s/logs/%(program_name)s-%(process_num)d.err.log

[supervisord]
loglevel = info
nodaemon = true
EOF
