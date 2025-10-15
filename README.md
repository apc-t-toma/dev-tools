# 開発環境ベースイメージ

このプロジェクトは、様々な開発環境で共通利用できるベースイメージを提供します。
Azure CLI、kubectl、Terraform、asdf、Git、SSH、GPGキーなどの基本的な開発ツールがプリインストールされており、イメージビルド時に自動でセットアップが実行されます。

## 特徴

- **マルチツール対応**: Azure CLI、kubectl、Terraform、asdfなど主要な開発ツールを統合
- **自動セットアップ**: Git設定、SSH/GPGキーの初期化が自動実行
- **カスタマイズ可能**: プロジェクト固有の要件に応じて拡張可能
- **言語環境サンプル**: Python開発環境、Node.js開発環境（VS Code開発コンテナ）の実装例を提供

## 基本的な使用方法

### 1. 環境設定

```bash
# .envファイルを作成
cp .env.example .env

# .envファイルを編集してメールアドレスと名前を設定
# EMAIL=your-email@example.com
# NAME=Your Full Name
```

### 2. ホストファイルの準備（オプション）

コンテナ内でホストのGit設定、SSHキー、GPGキーを使用したい場合は、以下のファイルを`import-files/`ディレクトリに配置してください。

#### Git 設定

```bash
# ホストのGit設定をコピー
cp ~/.gitconfig import-files/.gitconfig
```

#### SSH キー

```bash
# ホストのSSHキーをコピー
mkdir -p import-files/.ssh
cp ~/.ssh/id_* import-files/.ssh/
```

#### GPG キー

```bash
# GPGキーと信頼データベースをエクスポート
mkdir -p import-files/.gnupg
gpg --armor --export-secret-keys your-email@example.com > import-files/.gnupg/private-keys.asc
gpg --armor --export your-email@example.com > import-files/.gnupg/public-keys.asc
gpg --export-ownertrust > import-files/.gnupg/ownertrust.txt
```

**注意**:

- これらのファイルは機密情報を含むため、`.gitignore`で除外されています
- SSHキーやGPGキーは適切に管理し、不要になったら削除してください

### 3. ベースイメージのビルドと起動

以下のコマンドから目的に応じて選択して実行してください：

```bash
# 通常のビルドと起動
docker compose up --build

# バックグラウンドで起動したい場合
docker compose up --build -d

# ビルドのログを詳細表示したい場合
docker compose --progress plain build

# キャッシュを無効にしてクリーンビルドしたい場合
docker compose build --no-cache
```

### 4. コンテナへの接続

```bash
# コンテナに接続
docker compose exec workspace bash
```

### 5. 設定のエクスポート（オプション）

コンテナ内で使用されているGit、SSH、GPGの設定をworkspaceディレクトリにエクスポートできます。ホスト側でも同じ設定（Git設定、SSH接続、GPG署名など）を利用したい場合に、以下の手順を参考にしてください。

#### エクスポートされる設定

- **Git設定**: `.gitconfig`がworkspaceディレクトリにエクスポート
- **SSH設定**: SSH鍵とconfigが`workspace/.ssh/`にエクスポート
- **GPG設定**: GPG鍵と信頼設定が`workspace/.gnupg/`にエクスポート

#### エクスポートの実行

```bash
# バックグラウンドで起動
docker compose up -d

# エクスポートスクリプトを実行
docker compose exec workspace /export/export-settings.sh
```

#### エクスポートされるファイル

```text
workspace/
├── .gnupg/                      # GPG設定
│  ├── private-key-{email}.asc   # GPG秘密鍵
│  ├── public-key-{email}.asc    # GPG公開鍵
│  └── ownertrust-{email}.txt    # 信頼設定
├── .ssh/                        # SSH設定
│   ├── id_rsa                   # SSH秘密鍵
│   ├── id_rsa.pub               # SSH公開鍵
│   └── config                   # SSH設定ファイル
└── .gitconfig                   # Git設定
```

#### ホストへの設定コピー

エクスポートされた設定をホスト側で使用したい場合は、以下のコマンドでコピーできます。

##### Git設定のコピー

```bash
# Git設定をホストにコピー
cp workspace/.gitconfig ~/.gitconfig
```

##### SSH設定のコピー

```bash
# SSH設定をホストにコピー
cp -r workspace/.ssh/* ~/.ssh/
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

##### GPG設定のインポート

```bash
# GPG鍵をホストにインポート
gpg --import workspace/.gnupg/private-key-*.asc
gpg --import workspace/.gnupg/public-key-*.asc
gpg --import-ownertrust workspace/.gnupg/ownertrust-*.txt
```

**注意**:

- エクスポートされたファイルには機密情報が含まれるため、適切に管理してください
- これらのファイルは`.gitignore`で除外されています

## 含まれるツール

`script/` ディレクトリの各セットアップスクリプトを `Dockerfile` から呼び出しています。</br>
デフォルトでは `Dockerfile` 内のセットアップ行がすべてコメントアウトされており、追加ツールはインストールされません（素の Ubuntu + タイムゾーン設定のみ）。</br>
行頭の `#` を外すとそのツールがインストールされます。

### 利用可能なオプションツール一覧

- **SSH** (`ssh-setup.sh`) - SSH キー生成 / ホストからの継承
- **GPG** (`gpg-setup.sh`) - GPG キー生成 / ホストからのインポート
- **Git** (`git-setup.sh`) - Git / Git LFS 設定（GPG署名有効化を含む）
- **GitHub CLI** (`github-cli-setup.sh`) - `gh` コマンド
- **pnpm** (`pnpm-setup.sh`) - Node.js 用パッケージマネージャ（スタンドアロン）
- **libicu74** (`install-libicu74.sh`) - ICU 74
- **Azure CLI** (`azure-cli-setup.sh`) - Azure リソース操作
- **kubectl** (`kubectl-setup.sh`) - Kubernetes クラスタ操作
- **Terraform** (`terraform-setup.sh`) - IaC ツール
- **asdf** (`asdf-setup.sh`) - 複数言語 / ツールバージョン管理

#### カスタマイズ（例）

以下は Git / Azure CLI / Terraform をインストールする例:

```dockerfile
# SSH（無効）
# /tmp/script/ssh-setup.sh

# GPG（無効）
# /tmp/script/gpg-setup.sh

# Git（有効化）
/tmp/script/git-setup.sh

# GitHub CLI（無効）
# /tmp/script/github-cli-setup.sh

# pnpm（無効）
# /tmp/script/pnpm-setup.sh

# libicu74（無効）
# /tmp/script/install-libicu74.sh

# Azure CLI（有効化）
/tmp/script/azure-cli-setup.sh

# kubectl（無効）
# /tmp/script/kubectl-setup.sh

# Terraform（有効化）
/tmp/script/terraform-setup.sh

# asdf（無効）
# /tmp/script/asdf-setup.sh
```

### ツールの拡張と編集

追加ツールのセットアップは `script/` 配下の独立したスクリプトで管理します。

**注意点（ガイドライン）**:

- Dockerfile に直接 `apt-get install` を足さない（依存は各スクリプト内で完結）
- スクリプトは単体で再実行しても壊れない冪等性を維持
- `set -euo pipefail` で失敗検知

#### 既存スクリプトの編集（例）

`git-setup.sh` に独自のグローバル設定（例: 署名キー指定 / デフォルトブランチ名 / 差分表示改善）を追加する例:

```diff
@@
 git config --global user.name "$NAME"
+git config --global init.defaultBranch main
+git config --global diff.renames true
+# git config --global user.signingkey ABCDEF1234567890  # enable after key import
```

## 開発環境サンプルの使用

このベースイメージを基に、以下の開発環境サンプルを利用できます。

### Python開発環境

```bash
cd examples/python-dev
docker compose up --build
```

利用可能なコマンド:

- `docker compose exec python-dev python sample_app.py` - サンプルアプリケーション実行
- `docker compose exec python-dev pytest test_sample_app.py` - テスト実行
- `docker compose exec python-dev bash` - シェル起動

### Node.js開発環境（VS Code開発コンテナ）

VS Code開発コンテナを使用したNode.js開発環境のサンプルです。TypeScript、React、Next.js、Tailwind CSSを使用したWebアプリケーションの開発が可能です。

使用方法:

1. VS Codeで `examples/node-dev` フォルダを開く
2. **Command Palette** (Ctrl+Shift+P) を開く
3. "Dev Containers: Reopen in Container" を選択
4. コンテナのビルドと初期化を待つ
5. 初回起動時、自動的にNext.jsプロジェクトが作成されます

利用可能なコマンド:

- `npm run dev` - 開発サーバー起動
- `npm run build` - プロダクションビルド
- `npm run type-check` - 型チェック
- `npm run format` - コードフォーマット
- `npm run lint` - リント
