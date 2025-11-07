#!/bin/bash

# GitHub CLI セットアップスクリプト
# 概要: GitHub CLI (gh) の最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === GitHub CLI セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  wget \
  curl

# GitHub CLI GPGキーと署名のセットアップ
echo "GitHub CLI GPGキーをセットアップ中..."
mkdir -p /etc/apt/keyrings
chmod 755 /etc/apt/keyrings
out=$(mktemp)
wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
cat "$out" | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
# GitHub CLI aptリポジトリの追加
echo "GitHub CLI aptリポジトリを追加中..."
mkdir -p /etc/apt/sources.list.d
chmod 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# パッケージインデックスを更新してGitHub CLIをインストール
echo "GitHub CLI をインストール中..."
apt-get update -qq
apt-get install -qq -y gh

# インストール確認
if command -v gh &> /dev/null; then
  echo "✅ GitHub CLI のインストールが完了しました:"
  gh --version
else
  echo "❌ GitHub CLI のインストールに失敗しました"
  exit 1
fi

echo "🎉 === GitHub CLI セットアップ完了 ==="
