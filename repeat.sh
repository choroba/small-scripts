#!/bin/bash

# repeat.sh N command [arguments]
# Repeat the command N times, report the frequency of exit statuses.

times=$1
shift

declare -A status
for i in $(seq 1 "$times") ; do
    echo "$i/$times" >&2
    "$@"
    (( status[$?]++ ))
done

for code in "${!status[@]}" ; do
    echo "$code" "${status[$code]}x"
done | sort -nk2

