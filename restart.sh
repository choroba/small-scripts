#!/bin/bash
# Restart a command (used after zypper ps).

pid=$1
read __ command < <(ps x -o pid,args | grep "^ *$pid ")
kill $pid || kill -9 $pid
$command & disown
