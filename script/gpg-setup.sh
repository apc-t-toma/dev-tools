#!/bin/bash

# GPG セットアップスクリプト
# 概要: GPGキーの生成またはホストからのインポートを行います

set -euo pipefail

echo "🚀 === GPG セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  gnupg \
  rsync

# GPGディレクトリの初期設定
echo "GPGディレクトリを初期化中..."
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# ホストのGPGキーファイルをチェックしてインポート
if [ -d "/tmp/host/.gnupg" ] && [ "$(find /tmp/host/.gnupg -type f -name '*.asc' 2>/dev/null | wc -l)" -gt 0 ]; then
  echo "ホストGPGキーをインポート中..."

  # 秘密鍵と公開鍵をインポート
  for key_file in /tmp/host/.gnupg/*.asc; do
    if [ -f "$key_file" ]; then
      gpg --batch --yes --import "$key_file" 2>/dev/null || true
    fi
  done

  # 信頼度設定ファイルをインポート（存在する場合）
  for trust_file in /tmp/host/.gnupg/ownertrust*.txt; do
    if [ -f "$trust_file" ]; then
      gpg --import-ownertrust "$trust_file" 2>/dev/null || true
      break
    fi
  done

  echo "✅ ホストGPGキーのインポートが完了しました"
else
  echo "GPGキー用メール: $EMAIL"
  echo "GPGキー用名前: $NAME"

  echo "GPGキーを生成中（EdDSA/Ed25519）..."

  # GPGキー生成用の設定ファイルを作成（EdDSA/Ed25519）
  cat > /tmp/gpg-gen-key << EOF
Key-Type: EDDSA
Key-Curve: Ed25519
Subkey-Type: ECDH
Subkey-Curve: Curve25519
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
%no-protection
%commit
EOF

  # GPGキーを生成
  gpg --batch --generate-key /tmp/gpg-gen-key 2>/dev/null

  # 一時ファイルを削除
  rm -f /tmp/gpg-gen-key

  echo "✅ GPGキーの生成が完了しました"
fi

echo "🎉 === GPG セットアップ完了 ==="
