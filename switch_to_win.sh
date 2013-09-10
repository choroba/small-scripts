#! /bin/bash

function warn () {
    zenity --warning --title 'Switch to window' --text "$1 not found!"
}

app="$1"
app='['${app:0:1}"]${app:1}"
pids=$(ps x -ocomm,pid | grep "$app")
if [[ $pids ]] ; then
    while read app pid ; do
        id=$(wmctrl -p -l | grep " $pid \+$HOSTNAME")
        id=${id%% *}
        if [[ $id ]] ; then
            wmctrl -i -a "$id"
            ok=1
        fi
    done <<< "$pids"
fi

if ((!ok)) ; then
    warn "$1"
fi