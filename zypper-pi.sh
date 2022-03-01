#! /bin/bash
tmp=$(mktemp --tmpdir zypper-pi.XXXXXXXX) || exit 1
zypper -x lp > "$tmp"
grep -q '<update ' "$tmp" && xsh <<EOF | less
  quiet ;
  open "$tmp" ;
  for &{ sort :n :k (substring(@name, 19, 4) * 10000 + substring(@name, 24))
              ( /stream/update-status/update-list/update
              | /stream/update-status/blocked-update-list/update ) }
      echo @name {"\n"} (summary) {"\n"} (description) {"\n"} {"-" x 76} ;
EOF
rm "$tmp"
