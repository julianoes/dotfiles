#!/usr/bin/env bash

output=$(getent hosts "$1" | awk '{print $1}')

if [ -z "$output" ];
then
    # No output, assume IP
    echo "$1"
else
    # Got IP, use it
    echo "$output"
fi
