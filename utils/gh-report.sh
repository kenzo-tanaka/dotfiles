#!/bin/bash

# TODO: gh command check

if [ $# != 1 ]; then
  echo 'コミッター名を指定してください。'
  exit 1
fi

comitter=$1

# e.g. - [#1 title](https://github.com/test/pull/1)
md_list_format='"- [#" + (.number|tostring) + " " +  .title + "](" + .url + ")"'
gh pr list -a $1 --state closed --json url,title,number -q ".[] | .result = $md_list_format | .result"
