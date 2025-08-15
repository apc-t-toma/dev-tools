# ベースイメージとして共通の開発ツールを使用
FROM dev-tools-workspace:latest

# asdfを使ってNode.jsプラグインを追加
RUN <<EOF
echo "Node.jsプラグインを追加中..."
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
echo "Node.jsプラグインの追加が完了しました"
EOF
