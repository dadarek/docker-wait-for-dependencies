#!/bin/sh

: ${SLEEP_LENGTH:=2}
: ${TIMEOUT_LENGTH:=300}

wait_for() {
  START=$(date +%s)
  echo Waiting for $1 to listen on $2...
  while ! nc -z $1 $2;
    do
    if [ $(($(date +%s) - $START)) -gt $TIMEOUT_LENGTH ]; then
        echo timeout
        break
    fi
    echo sleeping;
    sleep $SLEEP_LENGTH;
  done
}

for var in "$@"
do
  host=${var%:*}
  port=${var#*:}
  wait_for $host $port
done
