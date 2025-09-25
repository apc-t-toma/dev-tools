#!/bin/bash

# kubectl セットアップスクリプト
# 概要: kubectlの最新安定版をUbuntuにインストールします

set -euo pipefail

echo "🚀 === kubectl セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  curl \
  gnupg \
  sudo

# 最新の安定版バージョンを取得
echo "kubectl の最新バージョンを確認中..."
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
KUBECTL_VERSION_SHORT=$(echo $KUBECTL_VERSION | cut -d'.' -f1,2)

echo "kubectl バージョン: $KUBECTL_VERSION"
echo "リポジトリバージョン: $KUBECTL_VERSION_SHORT"

# Kubernetesの公開署名キーをダウンロード
echo "Kubernetes 公開署名キーをダウンロード中..."
mkdir -p /etc/apt/keyrings
chmod 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION_SHORT}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Kubernetesのaptリポジトリを追加
echo "Kubernetes aptリポジトリを追加中..."
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION_SHORT}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list

# パッケージインデックスを更新してkubectlをインストール
echo "kubectl をインストール中..."
apt-get update
apt-get install -qq -y kubectl

# インストール確認
if command -v kubectl &> /dev/null; then
  echo "✅ kubectl のインストールが完了しました:"
  kubectl version --client
else
  echo "❌ kubectl のインストールに失敗しました"
  exit 1
fi

echo "🎉 === kubectl セットアップ完了 ==="
