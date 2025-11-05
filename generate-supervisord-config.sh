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

cat > supervisord.ini << EOF
[program:otelcol]
command=./run-collector.sh /usr/bin/otelcol-contrib --config config.yaml
environment=INSTANCE=%(process_num)d,DURATION=${DURATION},DELAY_START=${DELAY_START}
numprocs=${NUMPROCS}
process_name=%(program_name)s-%(process_num)d
stdout_logfile=%(here)s/logs/%(program_name)s-%(process_num)d.log
stderr_logfile=%(here)s/logs/%(program_name)s-%(process_num)d.err.log

[supervisord]
loglevel = info
nodaemon = true
EOF
