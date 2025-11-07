#!/bin/bash

# Terraform セットアップスクリプト
# 概要: Terraformの最新版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === Terraform セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  gnupg \
  lsb-release \
  sudo \
  wget

# HashiCorpの公開署名キーをダウンロード
echo "HashiCorp 公開署名キーをダウンロード中..."
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# HashiCorpのaptリポジトリを追加
echo "HashiCorp aptリポジトリを追加中..."
UBUNTU_CODENAME=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)
echo "Ubuntu コードネーム: $UBUNTU_CODENAME"

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# パッケージインデックスを更新してTerraformをインストール
echo "Terraform をインストール中..."
apt-get update -qq
apt-get install -qq -y terraform

# インストール確認
if command -v terraform &> /dev/null; then
  echo "✅ Terraform のインストールが完了しました:"
  terraform version
else
  echo "❌ Terraform のインストールに失敗しました"
  exit 1
fi

echo "🎉 === Terraform セットアップ完了 ==="
