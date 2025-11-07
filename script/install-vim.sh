#!/bin/bash

# vim インストールスクリプト
# 概要: vim のインストールを行います

set -euo pipefail

echo "🚀 === vim インストール開始 ==="

# 必要なパッケージのインストール
echo "vim をインストール中..."
apt-get install -qq -y \
  vim

echo "✅ vim のインストールが完了しました"

echo "🎉 === vim インストール完了 ==="
