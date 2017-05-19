#!/bin/sh
: ${SLEEP_LENGTH:=2}

SLEPT=0

keep_waiting(){
  if [ -n "$WAIT_FOR" ]; then
    if [ "$WAIT_FOR" -gt "$SLEPT" ]; then
      echo "waiting for ${WAIT_FOR}s current ${SLEPT}s"
      return 0
    else
      echo "Exceed waiting limit $SLEPT"
      exit 1
    fi
  else
    return 0
  fi
}

wait_for() {
  echo Waiting for $1 to listen on $2...
  while keep_waiting && ! nc -z $1 $2; do echo sleeping; sleep $SLEEP_LENGTH; SLEPT=$((SLEEP_LENGTH+SLEPT)); done
}

for var in "$@"
do
  host=${var%:*}
  port=${var#*:}
  wait_for $host $port
done
