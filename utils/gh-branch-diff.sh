#!/bin/bash

base_branch=`git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//"`
current_branch=`git branch --show-current`

git diff $base_branch $current_branchch --name-only