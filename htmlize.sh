#! /bin/bash
set -eu

server_file=/tmp/emacs$UID/server

new_emacs=0
if ! emacsclient --eval 't' &> /dev/null ; then
    echo Starting emacs... >&2
    emacs --eval '(server-mode)' &> /dev/null &
    i=0
    until emacsclient --eval 't' &> /dev/null ; do
        sleep .1
        ((++i > 20)) && break
    done
    new_emacs=1
    [[ -e $server_file ]]
fi

for file ; do
    if [[ -f $file ]] ; then
        if [[ $file -nt $file.html ]] ; then
            emacsclient --eval '(htmlize-file "'"$file"'")' &> /dev/null
            [[ $file.html -nt $file ]]
        else
            echo "$file.html" already exists >&2
        fi
    else
        echo "$file" not found, skipping... >&2
    fi
done

if (( new_emacs )) ; then
    emacsclient --eval '(kill-emacs)'
fi
