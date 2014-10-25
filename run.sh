#!/bin/sh
search='.*_PORT_\([0-9]*\)_TCP=tcp://\([a-zA-Z0-9.-]*\):\([0-9]*\)$'
socat_pids=""
trap "[ -n \"\$socat_pids\" ] && kill \$socat_pids" EXIT
for rule in `env | sed -n "\%$search%{s%$search%\1,\2:\3%;p}"`; do
    IFS=,
    set -- $rule
    src=$1
    dst=$2
    socat -ls TCP4-LISTEN:$src,fork,reuseaddr TCP4:$dst &
    socat_pids="$socat_pids $!"
done
wait
