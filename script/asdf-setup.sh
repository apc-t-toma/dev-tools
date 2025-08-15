#!/bin/bash

# asdf セットアップスクリプト
# 概要: asdf（Go版）をインストールし、初期設定を行います

set -euo pipefail

echo "🚀 === asdf セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  curl \
  jq

# asdfのインストール（Go版）
echo "asdf の最新バージョンを確認中..."
ASDF_VERSION=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | jq -r '.tag_name')
echo "asdf バージョン: $ASDF_VERSION"

echo "asdf をダウンロード中..."
curl -fsSL https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-amd64.tar.gz -o asdf.tar.gz

echo "asdf をインストール中..."
tar -xzf asdf.tar.gz -C /usr/local/bin
rm asdf.tar.gz

# asdfの初期設定
echo "asdf の初期設定中..."

# ASDF_DATA_DIRを設定
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bash_profile

# bash補完の設定
echo '. <(asdf completion bash 2>/dev/null || true)' >> /etc/bash.bashrc

# インストール確認
if command -v asdf &> /dev/null; then
    INSTALLED_VERSION=$(asdf version | head -n1 | awk '{print $1}')
    echo "✅ asdf のインストールが完了しました: v${INSTALLED_VERSION}"
else
    echo "❌ asdf のインストールに失敗しました"
    exit 1
fi

echo "🎉 === asdf セットアップ完了 ==="
