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

```bash
# ベースイメージをビルドして起動
docker compose up --build

# バックグラウンドで起動
docker compose up --build -d

# ビルドのログを詳細表示
docker compose --progress plain build

# キャッシュを無効にしてビルド
docker compose build --no-cache

# コンテナに接続
docker compose exec workspace bash
```

### 4. 設定のエクスポート（オプション）

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

- **Git** - バージョン管理（GPG署名対応）
- **SSH** - セキュア接続（ホストキー継承対応）
- **GPG** - 暗号化・署名（ホストキー継承対応）
- **Azure CLI** - Azure管理とリソース操作
- **kubectl** - Kubernetes管理
- **Terraform** - インフラストラクチャ・アズ・コード
- **asdf** - 言語・ツールのバージョン管理

## 自動セットアップ機能

このベースイメージは、イメージビルド時に以下の自動セットアップを実行します：

1. **ツールのインストール（ビルド時）**: Git、SSH、GPG、Azure CLI、kubectl、Terraform、asdfなどの開発ツール
2. **設定の適用（ビルド時）**: 指定されたメールアドレスと名前でのGit設定、（オプション）ホストキーの継承
3. **設定のエクスポート（手動実行）**: `.env`ファイルの設定を基に、コンテナ内の設定をworkspaceディレクトリへエクスポート

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
