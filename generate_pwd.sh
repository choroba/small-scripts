#! /bin/bash

length=10
regex='[-,.[:alnum:]]'

if [[ $1 =~ ^--?h(elp)?$ ]] ; then
    cat <<EOF
Usage: ${0##*/} [-l length] [-r char-regex]
  Defaults: length: $length, regex: $regex
EOF
    exit
fi

while getopts 'l:r:' arg ; do
    case $arg in
        l) length=$(($OPTARG)) || exit 1
            ;;
        r) regex=$OPTARG
            ;;
        *) echo Invalid option $arg. Use -h to get help. >&2
            exit 2
            ;;
    esac
done

export LC_ALL=C

cat /dev/urandom \
    | grep -ao "$regex" \
    | head -n$length \
    | perl -pechomp
echo
