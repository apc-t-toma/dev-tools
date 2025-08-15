#!/bin/bash

# GPG 設定エクスポートスクリプト
# 概要: コンテナ内のGPG設定をワークスペースにエクスポートします

set -euo pipefail

echo "  GPG設定をエクスポート中..."

# 入力パラメータの検証
if [ $# -lt 1 ]; then
    echo "❌ エラー: メールアドレスが指定されていません"
    exit 1
fi

EMAIL="$1"

# GPGキーの存在確認
if ! gpg --list-secret-keys "$EMAIL" &>/dev/null; then
    echo "❌ エラー: $EMAIL のGPG秘密鍵が見つかりません"
    exit 1
fi

# ワークスペースディレクトリの作成
mkdir -p /workspace/.gnupg

# 秘密鍵をエクスポート（ASCII形式）
if ! gpg --armor --export-secret-keys "$EMAIL" > "/workspace/.gnupg/private-key-$EMAIL.asc" 2>/dev/null; then
    echo "❌ エラー: GPG秘密鍵のエクスポートに失敗しました"
    exit 1
fi

# 公開鍵をエクスポート（ASCII形式）
if ! gpg --armor --export "$EMAIL" > "/workspace/.gnupg/public-key-$EMAIL.asc" 2>/dev/null; then
    echo "❌ エラー: GPG公開鍵のエクスポートに失敗しました"
    exit 1
fi

# 信頼度設定をエクスポート
if ! gpg --export-ownertrust > "/workspace/.gnupg/ownertrust-$EMAIL.txt" 2>/dev/null; then
    echo "⚠️  警告: 信頼度設定のエクスポートに失敗しました"
fi
