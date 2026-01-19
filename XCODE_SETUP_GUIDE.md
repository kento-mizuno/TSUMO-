# Xcodeプロジェクトセットアップガイド

## 現在の状況

基本的なXcodeプロジェクトファイル（`TSUMO.xcodeproj`）を作成しましたが、手動で作成したproject.pbxprojファイルは完全ではない可能性があります。

## 推奨される方法

### 方法1: Xcodeでプロジェクトを開いて確認

1. Xcodeを開く
2. `File > Open` を選択
3. `/Users/TSUMO!/TSUMO.xcodeproj` を選択
4. プロジェクトが正しく開けるか確認
5. エラーがあれば、Xcodeが自動的に修正してくれる可能性があります

### 方法2: Xcodeで新規プロジェクトを作成（推奨）

もし方法1で問題が発生した場合：

1. Xcodeを開く
2. "Create a new Xcode project"を選択
3. iOS > App を選択してNext
4. 以下の設定を入力:
   - Product Name: `TSUMO`
   - Team: あなたの開発チーム
   - Organization Identifier: `com.tsumo` (適宜変更)
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None` (Firebaseを使用するため)
5. 保存場所を `/Users/TSUMO!` に設定（既存のTSUMOフォルダとは別の場所、または既存のTSUMOフォルダを削除）
6. "Create"をクリック

### 既存ファイルをプロジェクトに追加

Xcodeプロジェクトが作成されたら：

1. Xcodeでプロジェクトを開く
2. プロジェクトナビゲーターで `TSUMO` フォルダを右クリック
3. "Add Files to TSUMO..."を選択
4. `/Users/TSUMO!/TSUMO` フォルダを選択
5. 以下のオプションを確認:
   - ✅ "Copy items if needed" のチェックを外す（既に正しい場所にあるため）
   - ✅ "Create groups" を選択
   - ✅ "Add to targets: TSUMO" を選択
6. "Add"をクリック

## 次のステップ

プロジェクトが正しく設定されたら：

1. Firebase SDKの追加
2. ビューとビューモデルの実装
3. サービスの実装

## トラブルシューティング

### プロジェクトが開けない場合

- Xcodeのバージョンを確認（Xcode 15.0以上推奨）
- project.pbxprojファイルの構文エラーを確認
- 方法2で新規プロジェクトを作成することを推奨

### ファイルが見つからない場合

- ファイルパスを確認
- Xcodeのプロジェクトナビゲーターでファイルを手動で追加
