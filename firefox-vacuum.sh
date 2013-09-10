#! /bin/bash
grep ^Path= ~/.mozilla/firefox/profiles.ini \
    | cut -f2 -d= \
    | while read profile ; do
    error=''
    cd ~/.mozilla/firefox/"$profile"
    profile=${profile%/}
    echo ${profile##*/}
    set *.sqlite
    echo -n Before:' '
    du "$@" | sum.pl
    echo -n '[' >&2
    for i in $(seq 1 $#) ; do
        echo -n . >&2
    done
    echo -en ']\r[' >&2
    for db ; do
        echo -n + >&2
        sqlite3 $db VACUUM\; 2>/dev/null
        if (($?)) ; then error+=$db' ' ; fi
    done
    echo ']' >&2
    echo -n After:' '
    du "$@" | sum.pl
    if [[ $error ]] ; then echo Problems: $error>&2 ; fi
done
