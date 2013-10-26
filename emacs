#!/bin/bash
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

if [[ -e /tmp/emacs$UID/server ]] ; then
    [[ $nw ]] || nw=-n
    /usr/bin/emacsclient $nw "${args[@]}" 2>/dev/null
else
    /usr/bin/emacs $nw --no-splash "${args[@]}"
fi
