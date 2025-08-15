#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリに移動
cd "$(dirname "$0")"

# エクスポート用envファイルのパス
readonly ENV_FILE="/run/secrets/export_env"

# envファイルの存在確認
validate_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        echo "❌ エラー: envファイルが見つかりません ($ENV_FILE)"
        exit 1
    fi

    if [ ! -r "$ENV_FILE" ]; then
        echo "❌ エラー: envファイルの読み取り権限がありません"
        exit 1
    fi
}

# エクスポート実行関数
run_export_with_isolated_env() {
    local script="$1"
    shift
    local args=("$@")

    # サブシェルで環境変数を読み込み、スクリプト実行
    (
        set -a
        # shellcheck source=/dev/null
        source "$ENV_FILE"
        set +a

        # 引数の検証
        if [ -z "${EMAIL:-}" ]; then
            echo "❌ エラー: envファイルに必要な値が設定されていません"
            exit 1
        fi

        # スクリプト実行
        "$script" "${args[@]}"
    ) || {
        echo "❌ $script の実行に失敗しました"
        exit 1
    }
}

# エクスポートメイン処理
execute_export() {
    # 環境変数の値を取得
    local temp_email
    temp_email=$(grep '^EMAIL=' "$ENV_FILE" | cut -d'=' -f2)

    if [ -n "$temp_email" ]; then
        echo "📧 $temp_email で設定をエクスポート中..."

        # Git, SSH, GPG 設定エクスポート
        run_export_with_isolated_env "./git-export.sh"
        run_export_with_isolated_env "./ssh-export.sh"
        run_export_with_isolated_env "./gpg-export.sh" "$temp_email"

    else
        echo "❌ エラー: envファイルから値を取得できませんでした"
        exit 1
    fi
}

# メイン処理の実行
main() {
    echo "📦 === 開発環境設定エクスポート開始 ==="

    validate_env_file
    execute_export

    echo "🎉 === 開発環境設定エクスポート完了 ==="
}

# スクリプトの実行
main
