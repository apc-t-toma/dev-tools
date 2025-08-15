#!/bin/bash

# Azure CLI セットアップスクリプト
# 概要: Azure CLIの最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === Azure CLI セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  curl \
  jq \
  sudo

# Azure CLIのインストール
echo "Azure CLIをインストール中..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# インストール確認
if command -v az &> /dev/null; then
    AZ_VERSION=$(az version --output json | jq -r '."azure-cli"')
    echo "✅ Azure CLI のインストールが完了しました: v${AZ_VERSION}"
else
    echo "❌ Azure CLI のインストールに失敗しました"
    exit 1
fi

echo "🎉 === Azure CLI セットアップ完了 ==="
