# Assets.xcassets

このフォルダに画像アセットを追加してください。

## 画像の追加方法

### 方法1: Xcodeで追加（推奨）

1. Xcodeのプロジェクトナビゲーターで`Assets.xcassets`を選択
2. 下部の`+`ボタンをクリック
3. `New Image Set`を選択
4. 画像セットの名前を設定（例: `character`, `logo`）
5. 画像ファイルをドラッグ&ドロップで追加
   - `1x`: 通常解像度（@1x）
   - `2x`: 高解像度（@2x）
   - `3x`: 超高解像度（@3x）

### 方法2: フォルダに直接追加

1. 画像セット用のフォルダを作成（例: `character.imageset`）
2. その中に`Contents.json`と画像ファイルを配置
3. Xcodeで`Assets.xcassets`を右クリック → `Add Files to "TSUMO"...`
4. 作成したフォルダを選択

## 使用方法

SwiftUIで画像を使用する場合：

```swift
Image("character")  // アセット名を指定
```
