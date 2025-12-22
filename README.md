
# OCR to File & Clipboard (Vertical Text Support)

macOSの「テキスト認識（Live Text）」エンジンを直接呼び出す、高速OCRツールです。  
画面の選択部分を文字認識してクリップボードとファイルに記録します。
画面のOCRツールはショートカット.appでも作れますが、こちらの方が起動が速く、連続使用も快適です。

## 特徴
- **縦書き対応**: 日本語の縦書きも正確に認識。
- **低レイテンシ**: ショートカット.appだけで作るよりも高速に動作。
- 認識したテキストはクリップボードに保存
- **ログ保存**: `~/Desktop/ocr_log.txt` にも自動で追記保存。

## 使い方
1. `ocr_tool` をビルドして/配置（Build & Setup Commands参照）。
1. ショートカット.appで「シェルスクリプトを実行」アクションを作成。
1. 作成したショートカットにキーボードショートカット（Cmd+Shift+2等）を割り当て。


---

# Build & Setup Commands (Terminal)


## コンパイル
```
swiftc ocr_tool.swift -o ocr_tool
```
## 実行バイナリの移動（パスが通っているところに移動させる。以下は例）
```
mv ocr_tool /usr/local/bin/
```
## 実行テスト
```
ocr_tool
```


