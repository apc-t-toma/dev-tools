#!/usr/bin/env python3
"""
シンプルなPython開発環境のサンプルアプリケーション
"""

def hello(name="World"):
    """挨拶メッセージを返します"""
    return f"Hello, {name}!"

def main():
    """メイン関数"""
    print(hello())
    print(hello("Python Developer"))

if __name__ == "__main__":
    main()
