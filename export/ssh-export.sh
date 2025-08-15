#!/bin/bash

# SSH 設定エクスポートスクリプト
# 概要: コンテナ内のSSH設定をワークスペースにエクスポートします

set -euo pipefail

echo "  SSH設定をエクスポート中..."

# SSH設定の存在確認
if [ ! -d ~/.ssh ]; then
    echo "❌ エラー: ~/.ssh ディレクトリが見つかりません"
    exit 1
fi

# SSH鍵ファイルの存在確認
if [ "$(find ~/.ssh -type f -name 'id_*' ! -name '*.pub' 2>/dev/null | wc -l)" -eq 0 ]; then
    echo "❌ エラー: SSH秘密鍵が見つかりません"
    exit 1
fi

# ワークスペースディレクトリの作成
mkdir -p /workspace/.ssh

# SSH設定をワークスペースにコピー
rsync --delete -aqz ~/.ssh/ /workspace/.ssh/
