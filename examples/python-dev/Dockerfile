# Python開発環境サンプル
# dev-tools-workspaceベースを使用
FROM dev-tools-workspace:latest

# Python固有の最小限のツールをインストール
RUN <<EOF
# 基本的なPython開発ツール
apt-get update -qq
apt-get install -qq -y \
  python3-pip \
  python3-venv \
  python3-dev

# pythonコマンドのシンボリックリンクを作成
ln -sf /usr/bin/python3 /usr/bin/python

# クリーンアップ
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

# エントリーポイントスクリプトをコピー
COPY ./dev-scripts/python-dev-entrypoint.sh /dev-scripts/python-dev-entrypoint.sh
RUN chmod +x /dev-scripts/python-dev-entrypoint.sh

ENTRYPOINT ["/dev-scripts/python-dev-entrypoint.sh"]
