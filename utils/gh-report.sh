#!/bin/bash

if [ $# != 1 ]; then
  echo 'コミッター名を指定してください。'
  exit 1
fi

comitter=$1

# e.g. - [#1 title](https://github.com/test/pull/1)
md_list_format='"- [#" + (.number|tostring) + " " +  .title + "](" + .url + ")"'
monday=$(date -vMonw "+%Y-%m-%d")
friday=$(date -vFriw "+%Y-%m-%d")
gh pr list -a $1 --search "closed:$monday..$friday" --state closed --json url,title,number -q ".[] | .result = $md_list_format | .result"
