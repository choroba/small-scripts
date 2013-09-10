#! /bin/bash
for file ; do
    if [[ -f $file ]] ; then
        /usr/bin/emacs -nw --eval '(progn (setq kill-emacs-hook nil)(htmlize-file "'"$file"'") (kill-emacs))' > /dev/null
    else
        echo "$file" not found, skipping... >&2
    fi
done
