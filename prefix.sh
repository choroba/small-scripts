#!/bin/bash
prefix=$1
shift
for file
  do mv "$file" "$prefix$file"
done