#!/bin/bash

# GitHub CLI セットアップスクリプト
# 概要: GitHub CLI (gh) の最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === GitHub CLI セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  wget \
  curl \
  sudo

# wgetが利用可能か確認し、必要に応じてインストール
echo "wget の確認とインストール中..."
(type -p wget >/dev/null || (apt-get update && apt-get install -y wget))

# GitHub CLI GPGキーと署名のセットアップ
echo "GitHub CLI GPGキーをセットアップ中..."
sudo mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp)
wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# GitHub CLI aptリポジトリの追加
echo "GitHub CLI aptリポジトリを追加中..."
sudo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# パッケージインデックスを更新してGitHub CLIをインストール
echo "GitHub CLI をインストール中..."
apt-get update
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
