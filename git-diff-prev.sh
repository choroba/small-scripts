#! /bin/bash
git diff $(git log | grep ^commit | sed -n '2{s/commit//;p}') HEAD
