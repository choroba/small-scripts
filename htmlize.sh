#! /bin/bash
set -eu

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
    server_file=$(emacsclient --eval 'server-socket-dir' | cut -d\" -f2)
    [[ -e $server_file ]]
fi

for file ; do
    dir=$(readlink -f "${file%/*}")
    name=${file##*/}
    if [[ -f "$file" ]] ; then
        if [[ "$file" -nt "$file".html ]] ; then
            emacsclient --eval '(progn(hl-line-mode 1)(set-language-environment "UTF-8")(hfy-copy-and-fontify-file "'"$dir"'" "'"$dir"'" "'"$name"'"))'
            [[ $file.html -nt $file ]]
            perl -i -ne '$l = /<body / .. m{</body}; print if $l > 1 && $l !~ /E/' "$file".html
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
