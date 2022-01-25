#!/bin/bash

if [ $# == 0 ]; then
  echo 'コミッター名を指定してください。'
  exit 1
fi

function closed_pull_requests() {
  md_list_format='"- [#" + (.number|tostring) + " " +  .title + "](" + .url + ")"'
  monday=$(date -vMonw "+%Y-%m-%d")
  friday=$(date -vFriw "+%Y-%m-%d")
  
  gh pr list -a $1 --search "closed:$monday..$friday" --state closed --json url,title,number -q ".[] | .result = $md_list_format | .result"
}

committers=("$@")
committers_length=$#

for i in $(seq $committers_length)
do
  closed_pull_requests ${committers[$i-1]}
done
