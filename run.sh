#!/bin/sh
search='.*_PORT_\([0-9]*\)_TCP=tcp://\([a-zA-Z0-9.-]*\):\([0-9]*\)$'
socat_cmd='socat -ls TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3'
replace="$socat_cmd \&"
sedscript="
\%$search%{
    s%$search%$replace%
    p
}
\${
    c \
    wait
    p
}
"
env | sed -n "$sedscript" | sh
