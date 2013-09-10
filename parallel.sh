#! /bin/bash

## Tries to run commands in parallel. Commands are read from STDIN one
## per line, or from a given file specified by -f.
## Author: Jan Stepanek

file='-'
proc_num=$(grep -c ^processor'\b' /proc/cpuinfo)
prefix=$HOSTNAME-$USER-$$
sleep=10

children=()
names=()

if [[ $1 =~ ^--?h(elp)?$ ]] ; then
    cat <<-HELP
	Usage: ${0##*/} [-f file] [-n max-processes] [-p tmp-prefix] -s [sleep]
	  Defaults:
	    STDIN for file
	    $proc_num for max-processes (number of processors)
	    $prefix for tmp-prefix
	    $sleep for sleep interval
	HELP
    exit
fi

function debug () {
    if ((DEBUG)) ; then
        echo "$@" >&2
    fi
}

function child_count () {
    debug Entering child_count "${children[@]}"
    child_count=0
    new_children=()
    for child in "${children[@]}" ; do
        debug Trying $child
        if kill -0 $child 2>/dev/null ; then
            debug ... exists
            let child_count++
            new_children+=($child)
        fi
    done

    children=("${new_children[@]}")
    echo $child_count
    debug Leaving child_count "${children[@]}"
}

while getopts 'f:n:p:s:' arg ; do
    case $arg in
        f ) file=$OPTARG ;;
        n ) proc_num=$((OPTARG)) ;;
        p ) prefix=$OPTARG;;
        s ) sleep=$OPTARG;;
        * ) echo "Warning: unknown option $arg" >&2 ;;
    esac
done

i=0
while read -r line ; do
    debug Reading $line
    name=$prefix.$i
    let i++
    names+=($name)

    while ((`child_count`>=proc_num)) ; do
        sleep $sleep
        debug Sleeping
    done

    eval $line 2>$name.e >$name.o &
    children+=($!)
    debug Running "${children[@]}"
done < <(cat $file)

debug Loop ended
wait
cat "${names[@]/%/.o}"
cat "${names[@]/%/.e}" >&2
rm "${names[@]/%/.o}" "${names[@]/%/.e}"
