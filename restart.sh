#!/bin/bash
# Restart a command (used after zypper ps).

pid=$1
read __ command < <(ps x -o pid,args | grep "^ *$pid ")

for sig in TERM INT QUIT ABRT KILL ; do
    kill -$sig $pid && break
    sleep 1
done

$command & disown
