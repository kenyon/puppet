#!/bin/bash

if type -P git &> /dev/null
then
    git --git-dir "$1/$2/.git" rev-parse HEAD
else
    date +%s
fi
