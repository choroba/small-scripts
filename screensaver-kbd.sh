#! /bin/bash

# Turn off keyboard layout when screensaver starts.

(
    shopt -s extglob
    xscreensaver-command -watch | while read state x ; do
        date
        echo $state
        if [[ $state == @(LOCK|BLANK) ]] ; then
            until setxkbmap -query | grep 'layout: *us$' ; do
                setxkbmap -option '' -option ctrl:nocaps us
                sleep .1
            done
        elif [[ $state == UNBLANK ]] ; then
            until setxkbmap -query | grep 'layout: *us,cz' ; do
                setxkbmap -option '' \
                          -option ctrl:nocaps us,'cz(qwerty)' \
                          -option grp:shift_toggle
                sleep .1
            done
        fi
    done
) &
