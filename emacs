#!/bin/bash
dir=/usr/local/bin
declare -a args
unset nw
for arg ; do
    if [[ $arg =~ .:[0-9]+$ ]] ; then
        line="${arg##*:}"
        args+=("+$line")
        file="${arg%:*}"
    elif [[ $arg == '-nw' ]] ; then
        nw=-nw
        continue
    else
        file="$arg"
    fi
    args+=("$file")
done

if [[ -e /run/user/$UID/emacs/server || -e /tmp/emacs$UID/server ]] ; then
    exec "$dir"/emacsclient $nw "${args[@]}" 2>/dev/null
else
    exec "$dir"/emacs $nw --no-splash "${args[@]}"
fi
