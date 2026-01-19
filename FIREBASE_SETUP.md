# Firebaseセットアップガイド

## 1. Firebaseプロジェクトの作成

1. [Firebase Console](https://console.firebase.google.com/)にアクセス
2. 「プロジェクトを追加」をクリック
3. プロジェクト名を入力（例: `TSUMO`）
4. Google Analyticsの設定（任意）
5. プロジェクトを作成

## 2. iOSアプリの追加

1. Firebase Consoleでプロジェクトを選択
2. iOSアイコンをクリック
3. 以下の情報を入力:
   - **バンドルID**: `com.tsumo.app` (XcodeプロジェクトのBundle Identifierと一致させる)
   - **アプリのニックネーム**: `TSUMO` (任意)
   - **App Store ID**: 空白でOK（後で追加可能）
4. 「アプリを登録」をクリック

## 3. GoogleService-Info.plistのダウンロード

1. `GoogleService-Info.plist`ファイルをダウンロード
2. Xcodeプロジェクトに追加:
   - Xcodeでプロジェクトを開く
   - プロジェクトナビゲーターで `TSUMO` フォルダを右クリック
   - "Add Files to TSUMO..."を選択
   - ダウンロードした `GoogleService-Info.plist` を選択
   - ✅ "Copy items if needed" にチェック
   - ✅ "Add to targets: TSUMO" にチェック
   - "Add"をクリック

## 4. Firebase SDKの追加（Swift Package Manager）

1. Xcodeでプロジェクトを開く
2. プロジェクトナビゲーターでプロジェクト名（TSUMO）を選択
3. "Package Dependencies"タブを選択
4. "+"ボタンをクリック
5. 以下のURLを入力:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
6. "Add Package"をクリック
7. 以下のパッケージを選択:
   - ✅ FirebaseAuth
   - ✅ FirebaseFirestore
   - ✅ FirebaseFirestoreSwift
8. "Add Package"をクリック

## 5. 認証の設定

### Apple Sign Inの設定

1. Firebase Consoleで「Authentication」を選択
2. 「Sign-in method」タブを開く
3. 「Apple」を有効化
4. サービスIDを設定（必要に応じて）

### Email認証の設定

1. Firebase Consoleで「Authentication」を選択
2. 「Sign-in method」タブを開く
3. 「メール/パスワード」を有効化

## 6. Firestore Databaseの設定

1. Firebase Consoleで「Firestore Database」を選択
2. 「データベースを作成」をクリック
3. セキュリティルールを設定（開発中はテストモードでOK）
4. ロケーションを選択（例: `asia-northeast1` - 東京）

## 7. セキュリティルール（後で設定）

開発中はテストモードを使用し、本番環境では以下のようなルールを設定:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: 自分のデータのみ読み書き可能
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Groups: メンバーのみ読み書き可能
    match /groups/{groupId} {
      allow read: if request.auth != null && 
                     request.auth.uid in resource.data.members;
      allow write: if request.auth != null && 
                      (request.auth.uid == resource.data.createdBy ||
                       request.auth.uid in resource.data.members);
    }
    
    // Games: グループメンバーまたは作成者のみ読み書き可能
    match /games/{gameId} {
      allow read: if request.auth != null && 
                     (resource.data.groupId == null ||
                      request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.members);
      allow write: if request.auth != null;
    }
  }
}
```

## 8. アプリでの初期化

`TSUMOApp.swift`でFirebaseを初期化する必要があります（次のステップで実装します）。
