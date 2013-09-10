#!/bin/bash
temp=`mktemp`
touch $temp || {
    echo "Can't create temp file." 
    exit 2
}
if (( ${#@} > 0 )) ; then
    from=("$@")
else
    from=([0]=.)
fi
for file in "${from[@]}" ; do
    find "$file" -type f -exec md5sum {} \; >> $temp
done

for md in $(
    cut -f1 -d' ' $temp | sort | uniq -c | sort -nr | grep -v '^ *1 ' | rev | cut -f1 -d' ' | rev
) ; do
  echo --- $md ---
  grep $md $temp | rev | cut -f1 -d' ' | rev
done

rm -f $temp
