#!/bin/bash

CURRENT_BRANCH=$(git branch --show-current)

DIFF=$(git diff main..."$CURRENT_BRANCH")

TEXT="あなたはプログラマーです。
以下のgit diffの差分を下記の出力形式に沿って、簡潔にまとめてください。

# 出力言語
日本語

# 出力形式
* タイトル: {差分変更に関して簡潔に説明}
* 種別: {リファクタリング|機能追加|バグ修正|その他}
* 修正内容: {リスト構造。各リストは50文字以内}

# 差分
$DIFF"

# jqを使用して安全にJSONを生成
JSON_PAYLOAD=$(jq -n \
                  --arg model "gpt-4" \
                  --arg content "$TEXT" \
                  '{
                    "model": $model,
                    "messages": [
                      {
                        "role": "system",
                        "content": "You are a helpful assistant."
                      },
                      {
                        "role": "user",
                        "content": $content
                      }
                    ]
                  }')

# curlコマンドを使用してAPIを呼び出す
curl -X 'POST' https://api.openai.com/v1/chat/completions \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $OPENAI_API_KEY" \
     -d "$JSON_PAYLOAD" | jq -r '.choices[0].message.content'
