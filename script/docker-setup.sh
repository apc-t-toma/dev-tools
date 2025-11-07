#!/bin/bash

# Docker Engine セットアップスクリプト
# 概要: Ubuntuに公式リポジトリからDocker Engine最新版(stable)をインストールします。
# 参考: https://docs.docker.com/engine/install/ubuntu/

set -euo pipefail

echo "🚀 === Docker Engine セットアップ開始 ==="

echo "🧹 旧バージョン/競合パッケージの削除中..."
apt-get remove -qq -y \
  docker.io \
  docker-doc \
  docker-compose \
  docker-compose-v2 \
  podman-docker \
  containerd \
  runc \

echo "📦 事前必要パッケージをインストール中..."
apt-get install -qq -y \
  ca-certificates \
  curl

echo "🔐 GPGキー格納ディレクトリの準備中..."
install -m 0755 -d /etc/apt/keyrings

echo "🔑 Docker公式GPGキーを取得中..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 パッケージインデックス更新中..."
apt-get update -qq

echo "🐳 Docker Engine関連パッケージをインストール中..."
apt-get install -qq -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "🧪 インストール検証中..."
if command -v docker &> /dev/null; then
  echo "✅ docker コマンド検出: $(command -v docker)"
  docker --version
  echo "🔧 Buildx プラグイン確認:"; docker buildx version || echo "⚠️ buildx 未確認"
  echo "🧩 compose プラグイン確認:"; docker compose version || echo "⚠️ compose 未確認"
else
  echo "❌ docker コマンドが見つかりません。インストールに失敗しました。"
  exit 1
fi

echo "🎉 === Docker Engine セットアップ完了 ==="
