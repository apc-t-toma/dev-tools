#!/bin/bash

# Azure CLI セットアップスクリプト
# 概要: Azure CLIの最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === Azure CLI セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  curl

# Azure CLIのインストール
echo "Azure CLIをインストール中..."
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# インストール確認
if command -v az &> /dev/null; then
  echo "✅ Azure CLI のインストールが完了しました:"
  az version
else
  echo "❌ Azure CLI のインストールに失敗しました"
  exit 1
fi

echo "🎉 === Azure CLI セットアップ完了 ==="
