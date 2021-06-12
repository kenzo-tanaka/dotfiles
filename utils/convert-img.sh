#!/bin/bash

if [ $# != 1 ]; then
  echo "ファイル名を指定してください。"
  exit 1
fi

filename=${1%.*}

declare -a quality_array=(30 40 50 60 70 80 90)
for quality in "${quality_array[@]}"
do
  convert -quality $quality% $1 $filename-$quality.jpeg
done
