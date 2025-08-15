import pytest
from sample_app import hello

def test_hello_default():
    """デフォルトの挨拶をテスト"""
    assert hello() == "Hello, World!"

def test_hello_with_name():
    """名前を指定した挨拶をテスト"""
    assert hello("Python") == "Hello, Python!"
