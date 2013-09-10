#! /bin/bash

if ((!$#)) ; then
    echo No input file given.>&2
    exit 1
fi

tmp_uu=$(mktemp) || { echo Cannot create tmp >&2 ; exit 1 ; }
tmp_out=$(mktemp) ||  { echo Cannot create tmp >&2 ; exit 1 ; }

file=$1

{
    echo begin-base64 0644 "$tmp_out"
    cat "$file"
    echo $'====\nend'
} > "$tmp_uu"
uudecode "$tmp_uu"
cat "$tmp_out"
rm "$tmp_uu" "$tmp_out"
