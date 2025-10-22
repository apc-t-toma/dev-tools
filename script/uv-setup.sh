#!/bin/bash

# uv セットアップスクリプト
# 概要: Python パッケージマネージャー uv をスタンドアロンインストールします

set -euo pipefail

echo "🚀 === uv セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  curl

# uvのスタンドアロンインストール
echo "uv をインストール中..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# bash補完の設定
echo "bash補完を設定中..."
echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc
echo 'eval "$(uvx --generate-shell-completion bash)"' >> ~/.bashrc

# インストール確認（一時的にPATHを設定）
export PATH="$HOME/.local/bin:$PATH"
if command -v uv &> /dev/null; then
  echo "✅ uv のインストールが完了しました:"
  uv --version
else
  echo "❌ uv のインストールに失敗しました"
  exit 1
fi

echo "🎉 === uv セットアップ完了 ==="
