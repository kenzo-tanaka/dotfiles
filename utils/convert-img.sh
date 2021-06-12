#!/bin/bash

# TODO: 引数をチェック
# 引数: ファイル名(文字列/必須), 変換後拡張子(文字列/任意)

filename=${1%.*}

# TODO: qualityは30-80まで10刻みで実行
convert -quality 30% $1 $filename-30.jpeg
convert -quality 40% $1 $filename-40.jpeg

# for file in *.jpeg
# do
#   convert -quality 50% $file ./00_compress/${file%.*}.jpeg
#   rm $file
# done
