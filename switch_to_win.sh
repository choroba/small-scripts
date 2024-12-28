#! /bin/bash

function warn () {
    yad --image dialog-warning --title 'Switch to window' --text "$1 not found!"
}

app="$1"
app='['${app:0:1}"]${app:1}"
pids=$(ps x -ocomm,pid | grep "$app")
if [[ $pids ]] ; then
    while read app pid ; do
        id=$(wmctrl -p -l | grep " $pid \+\($HOSTNAME\|N/A\)")
        id=${id%% *}
        if [[ $id ]] ; then
            wmctrl -i -a "$id"
            wmctrl -i -a "$id"  # Needed after a desktop change.
            ok=1
        fi
    done <<< "$pids"
fi

if ((!ok)) ; then
    (   app=$1
        app=${app%-gtk}
        type "$app" &>/dev/null || warn "Cannot find or start $1"
        exec "$app"
    ) &
fi
