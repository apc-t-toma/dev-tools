#!/bin/bash

# ビルド引数バリデーションスクリプト
# 使用法: validate-args.sh <EMAIL> <NAME>

set -euo pipefail

EMAIL="$1"
NAME="$2"

# バリデーションエラーフラグ
HAS_ERROR=false

echo "🚀 === ビルド引数バリデーション開始 ==="

# EMAIL のバリデーション
if [ -z "$EMAIL" ]; then
  echo "❌ エラー: EMAIL引数が指定されていません"
  HAS_ERROR=true
elif ! echo "$EMAIL" | grep -E "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" > /dev/null; then
  echo "❌ エラー: 有効なメールアドレス形式ではありません: $EMAIL"
  HAS_ERROR=true
fi

# NAME のバリデーション
if [ -z "$NAME" ]; then
  echo "❌ エラー: NAME引数が指定されていません"
  HAS_ERROR=true
elif [ -z "$(echo "$NAME" | tr -d '[:space:]')" ]; then
  echo "❌ エラー: NAME引数が空または空白文字のみです"
  HAS_ERROR=true
fi

# バリデーション結果の処理
if [ "$HAS_ERROR" = true ]; then
  cat << EOF

正しい使用例：
  1. .envファイルを作成:
     cp .env.example .env

  2. .envファイルを編集してメールアドレスと名前を設定:
     EMAIL=your-email@example.com
     NAME=Your Name

  3. Docker Composeでビルド:
     docker compose build

  または直接ビルド引数を指定:
     docker build --build-arg EMAIL="your-email@example.com" --build-arg NAME="Your Name" .
EOF
  exit 1
else
  echo "🎉 バリデーション完了: EMAIL=$EMAIL, NAME=$NAME"
fi
