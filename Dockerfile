FROM ubuntu

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# メールアドレスと名前をARGで受け取る
ARG EMAIL
ARG NAME

# 作業ディレクトリを設定
WORKDIR /workspace

COPY ./import-files/ /tmp/host/
COPY ./script/ /tmp/script/

# パッケージインストールと設定
RUN <<EOF
# タイムゾーンの設定
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# パッケージアップデート
# 追加インストールやセットアップに必要なパッケージは、それぞれのシェルスクリプトでインストールしてください
apt-get update -qq

# スクリプトに実行権限を付与
chmod +x /tmp/script/*.sh

echo -e "\n\033[1;44;97m▓▓▓ 🚀 開発環境セットアップ開始 🚀 ▓▓▓\033[0m\n"

# ビルド引数のバリデーション
/tmp/script/validate-args.sh "$EMAIL" "$NAME"

echo -e "\n\033[1;46;30m▓▓▓ 🔧 各種ツールのインストールと設定 🔧 ▓▓▓\033[0m\n"
# 以降のインストールは、コメントアウトやスクリプトの追加・変更など、必要に応じてカスタマイズしてください。

# vim のインストール
# /tmp/script/install-vim.sh

# SSHのセットアップ
# /tmp/script/ssh-setup.sh

# GPGのセットアップ
# /tmp/script/gpg-setup.sh

# Gitのインストール
# /tmp/script/git-setup.sh

# GitHub CLIのインストール
# /tmp/script/github-cli-setup.sh

# Dockerのインストール
# /tmp/script/docker-setup.sh

# pnpmのインストール
# /tmp/script/pnpm-setup.sh

# uvのインストール
# /tmp/script/uv-setup.sh

# libicu74 のインストール
# /tmp/script/install-libicu74.sh

# Azure CLIのインストール
# /tmp/script/azure-cli-setup.sh

# kubectlのインストール
# /tmp/script/kubectl-setup.sh

# Terraformのインストール
# /tmp/script/terraform-setup.sh

# asdfのインストール
# /tmp/script/asdf-setup.sh

# PostgreSQLクライアントのインストール
# /tmp/script/postgresql-client-setup.sh

# 不要なパッケージを削除
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

# tmpディレクトリの中身を完全削除（隠しファイルも含む）
find /tmp -mindepth 1 -delete

echo -e "\n\033[1;42;30m▓▓▓ ✅ セットアップ完了 ✅ ▓▓▓\033[0m\n"

EOF
