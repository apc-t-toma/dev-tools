#!/bin/bash

# Python開発環境エントリーポイント

set -euo pipefail

echo "=== Python開発環境を開始 ==="

# requirements.txtがある場合は依存関係をインストール
if [ -f "requirements.txt" ]; then
    echo "requirements.txtが見つかりました。依存関係をインストール中..."
    pip install --break-system-packages -r requirements.txt
    echo "依存関係のインストールが完了しました"
fi

echo "=== Python環境の準備完了 ==="

# 引数に応じてコマンド実行
if [[ $# -gt 0 ]]; then
    echo "指定されたコマンド '$*' を実行します"
    exec "$@"
else
    echo "bashシェルを起動します"
    exec bash
fi
