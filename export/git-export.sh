#!/bin/bash

# Git 設定エクスポートスクリプト
# 概要: コンテナ内のGit設定をワークスペースにエクスポートします

set -euo pipefail

echo "  Git設定をエクスポート中..."

if [ ! -f ~/.gitconfig ]; then
    echo "❌ エラー: .gitconfigファイルが見つかりません"
    exit 1
fi

rsync -aqz ~/.gitconfig /workspace/.gitconfig
