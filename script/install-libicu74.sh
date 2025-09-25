#!/bin/bash

# libicu74 インストールスクリプト
# 概要: libicu74 のインストールを行います

set -euo pipefail

echo "🚀 === libicu74 インストール開始 ==="

# 必要なパッケージのインストール
echo "libicu74 をインストール中..."
apt-get install -qq -y libicu74

echo "✅ libicu74 のインストールが完了しました"

echo "🎉 === libicu74 インストール完了 ==="
