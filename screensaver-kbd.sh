#! /bin/bash

# Turn off keyboard layout when screensaver starts.

get_switch () {
    if ps x | grep -q '[s]ynergys' ; then
        switch=ctrls
    else
        switch=shifts
    fi
    printf '%s\n' "$switch"
}

(
    shopt -s extglob
    xscreensaver-command -watch | while read state x ; do
        date
        echo $state
        if [[ $state == @(LOCK|BLANK) ]] ; then
            setxkbmap -option '' -option ctrl:nocaps -layout us
        elif [[ $state == UNBLANK ]] ; then
            switch=$(get_switch)
            setxkbmap -option '' \
                      -option ctrl:nocaps -layout us,'cz(qwerty)' \
                      -option grp:${switch}_toggle
        fi
    done
) &
