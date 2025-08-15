#!/bin/bash

# devcontainer作成後に実行されるセットアップスクリプト

set -euo pipefail

echo "🚀 devcontainer セットアップを開始します..."

# .tool-versionsからバージョンを読み込み・インストール
if [ -f ".tool-versions" ]; then
    echo "🔧 .tool-versionsからNode.jsバージョンを読み込み・インストール中..."
    asdf install
    echo "✅ 指定されたNode.jsバージョンがインストールされました"
else
    echo "⚠️  .tool-versionsファイルが見つかりません。LTSバージョンをインストールします..."
    asdf install nodejs lts
    echo "nodejs lts" > .tool-versions
fi

# Node.jsとnpmのバージョン確認
echo "📋 インストール済みバージョン:"
node --version
npm --version

# グローバル開発ツールのインストール
echo "🛠️  グローバル開発ツールをインストール中..."
npm install -g \
  typescript \
  @types/node \
  eslint \
  prettier \
  create-next-app \
  @vitejs/create-app \
  pnpm \
  yarn
echo "✅ グローバル開発ツールのインストールが完了しました"

# package.jsonが存在しない場合は、サンプルプロジェクトを作成
if [ ! -f "package.json" ]; then
    echo "📦 サンプルのNext.jsプロジェクトを作成中..."

    # Next.jsプロジェクトの作成
    npx create-next-app@latest . \
        --typescript \
        --tailwind \
        --eslint \
        --app \
        --src-dir \
        --import-alias "@/*" \
        --use-npm

    echo "✅ Next.jsプロジェクトが作成されました"
else
    echo "📦 既存のプロジェクトが見つかりました。依存関係をインストール中..."

    # パッケージマネージャーを自動検出してインストール
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm を使用して依存関係をインストール中..."
        pnpm install
    elif [ -f "yarn.lock" ]; then
        echo "yarn を使用して依存関係をインストール中..."
        yarn install
    else
        echo "npm を使用して依存関係をインストール中..."
        npm install
    fi
    echo "✅ 依存関係のインストールが完了しました"
fi

# 開発用の追加パッケージをインストール
echo "🛠️  開発用パッケージを追加中..."
npm install --save-dev \
    @types/react \
    @types/react-dom \
    prettier \
    eslint-config-prettier

# prettier設定ファイルを作成
if [ ! -f ".prettierrc" ]; then
    cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
EOF
fi

echo "✅ devcontainer セットアップが完了しました！"
echo "💡 開発を開始するには: npm run dev"
