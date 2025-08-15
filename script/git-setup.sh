#!/bin/bash

# Git セットアップスクリプト
# 概要: Gitの設定とgit-lfsのセットアップを行います

set -euo pipefail

echo "🚀 === Git セットアップ開始 ==="

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
apt-get install -qq -y \
  git \
  git-lfs \
  rsync

# ホストの.gitconfigファイルの確認とコピー
if [ -f "/tmp/host/.gitconfig" ] && [ -s "/tmp/host/.gitconfig" ]; then
  echo "ホストの.gitconfigファイルが見つかりました。コピー中..."
  rsync -aqz /tmp/host/.gitconfig ~/.gitconfig
  echo "✅ ホストの.gitconfigファイルをコピーしました"
else
  echo "Gitグローバル設定を適用中..."
  echo "メール: $EMAIL"
  echo "名前: $NAME"

  # gitの設定
  git config --global commit.gpgsign true
  git config --global core.autocrlf false
  git config --global core.fscache true
  git config --global core.quotepath false
  git config --global core.symlinks false
  git config --global fetch.prune true
  git config --global fetch.pruneTags true
  git config --global pull.rebase true
  git config --global user.email "$EMAIL"
  git config --global user.name "$NAME"

  # git-lfsのインストール
  echo "Git LFS を初期化中..."
  git lfs install

  echo "✅ Git セットアップが完了しました"
fi

echo "🎉 === Git セットアップ完了 ==="
