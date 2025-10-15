#!/bin/bash

# pnpm セットアップスクリプト
# 概要: pnpmの最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === pnpm セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  wget

# pnpmのインストール（Docker container用の公式スタンドアロンスクリプトを使用）
echo "pnpm をインストール中..."
wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -

# インストール確認（インストール直後でもpnpmが利用可能になる）
# 注意: 新しいシェルセッションでPATHが有効になるため、現在のセッションでは手動でPATHを設定
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# インストール確認
if command -v pnpm &> /dev/null; then
  echo "✅ pnpm のインストールが完了しました:"
  pnpm --version
else
  echo "❌ pnpm のインストールに失敗しました"
  exit 1
fi

echo "🎉 === pnpm セットアップ完了 ==="
