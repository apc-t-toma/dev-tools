#!/bin/bash

# PostgreSQL Client セットアップスクリプト
# 概要: PostgreSQL Client (psql) をUbuntuにインストールします

set -euo pipefail

echo "🚀 === PostgreSQL Client セットアップ開始 ==="

# PostgreSQL Clientのインストール
echo "PostgreSQL Client をインストール中..."
apt-get install -qq -y postgresql-client

# インストール確認
if command -v psql &> /dev/null; then
  echo "✅ PostgreSQL Client のインストールが完了しました:"
  psql --version
else
  echo "❌ PostgreSQL Client のインストールに失敗しました"
  exit 1
fi

echo "🎉 === PostgreSQL Client セットアップ完了 ==="
