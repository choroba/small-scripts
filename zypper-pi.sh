#! /bin/bash
tmp=$(mktemp --tmpdir zypper-pi.XXXXXXXX) || exit 1
zypper -x lp > "$tmp"
grep -q '<update ' "$tmp" && xsh <<EOF | less
  quiet ;
  open "$tmp" ;
  for &{ sort :n :k issue-date/@time_t
              ( /stream/update-status/update-list/update
              | /stream/update-status/blocked-update-list/update ) }
      echo @name {"\n"} (summary) {"\n"} (description) {"\n"} {"-" x 76} ;
EOF
rm "$tmp"
