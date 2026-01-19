# Xcodeプロジェクトセットアップ手順

## 方法1: Xcodeで新規プロジェクトを作成

1. Xcodeを開く
2. "Create a new Xcode project"を選択
3. iOS > App を選択してNext
4. 以下の設定を入力:
   - Product Name: `TSUMO`
   - Team: あなたの開発チーム
   - Organization Identifier: `com.yourcompany` (適宜変更)
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None` (Firebaseを使用するため)
5. 保存場所を `/Users/TSUMO!` に設定
6. "Create"をクリック

## 方法2: 既存のファイルをプロジェクトに追加

Xcodeプロジェクトを作成した後、以下のファイルをプロジェクトに追加してください:

1. Xcodeでプロジェクトを開く
2. プロジェクトナビゲーターで右クリック > "Add Files to TSUMO..."
3. 以下のフォルダとファイルを選択:
   - `TSUMO/Models/` フォルダ全体
   - その他のSwiftファイル

## Firebase SDKの追加

1. Xcodeでプロジェクトを開く
2. File > Add Package Dependencies...
3. 以下のURLを入力:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
4. 以下のパッケージを選択:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseFirestoreSwift

## 次のステップ

プロジェクトが作成されたら、以下の作業を続けます:
- Firebase設定ファイル（GoogleService-Info.plist）の追加
- ビューとビューモデルの実装
- サービスの実装
