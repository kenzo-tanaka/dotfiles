#!/bin/bash

if [ $# == 0 ]; then
  echo 'コミッター名を指定してください。'
  exit 1
fi
monday=$(date -vMonw "+%Y-%m-%d")
friday=$(date -vFriw "+%Y-%m-%d")

function closed_pull_requests() {
  md_list_format='"- #" + (.number|tostring) + " " +  .title + " [done]"'
  committer_name=$1
  echo -e "\n""$committer_name""\n"

  gh pr list -A $committer_name --search "closed:$monday..$friday" --state closed --json url,title,number,state -q ".[] | .result = $md_list_format | .result"
}

function open_pull_requests() {
  md_list_format='"- #" + (.number|tostring) + " " +  .title + " [doing]"'
  committer_name=$1

  gh pr list -A $committer_name --state open --json url,title,number,state -q ".[] | .result = $md_list_format | .result"
}

committers=("$@")
committers_length=$#

for i in $(seq $committers_length)
do
  closed_pull_requests ${committers[$i-1]}
  open_pull_requests ${committers[$i-1]}
done
