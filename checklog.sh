#! /bin/bash

if [[ $1 == -h || $1 == --help ]] ; then
    echo Usage: "$0 [ -p additional-pattern-to-remove ]  [ files (empty if coming from STDIN) ]"
    exit
fi

if [[ $1 == -p* ]] ; then
    if [[ $1 == -p?* ]] ; then
        pattern=${1#-p}
        shift
    else
        shift
        pattern=$1
        shift
    fi
fi

if [[ $pattern ]] ; then
    pattern="s/$pattern/Y/g;"
fi

sed -r "$pattern"'s/[0-9]+/X/g' "$@" | sort | uniq -c | sort -nr
