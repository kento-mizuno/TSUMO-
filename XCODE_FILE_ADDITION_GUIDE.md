# Xcodeプロジェクトへのファイル追加手順

## 手動作業が必要な項目

以下の手順を**必ずXcodeで実行**してください。

---

## ステップ1: Xcodeプロジェクトを開く

1. Xcodeを起動
2. `File > Open` を選択
3. `/Users/TSUMO!/TSUMO.xcodeproj` を選択して開く

---

## ステップ2: ファイルをプロジェクトに追加

### 2-1. Viewsフォルダの追加

1. Xcodeのプロジェクトナビゲーター（左側）で、`TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. ファイル選択ダイアログで、`/Users/TSUMO!/TSUMO/Views` フォルダを選択
4. **重要**: 以下のオプションを設定:
   - ✅ **"Create groups"** を選択（"Create folder references" ではない）
   - ✅ **"Add to targets: TSUMO"** にチェック
   - ❌ **"Copy items if needed"** のチェックを**外す**（既に正しい場所にあるため）
5. `Add` をクリック

### 2-2. ViewModelsフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/ViewModels` フォルダを選択
4. オプション設定:
   - ✅ **"Create groups"** を選択
   - ✅ **"Add to targets: TSUMO"** にチェック
   - ❌ **"Copy items if needed"** のチェックを**外す**
5. `Add` をクリック

### 2-3. Servicesフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/Services` フォルダを選択
4. オプション設定:
   - ✅ **"Create groups"** を選択
   - ✅ **"Add to targets: TSUMO"** にチェック
   - ❌ **"Copy items if needed"** のチェックを**外す**
5. `Add` をクリック

### 2-4. Utilitiesフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/Utilities` フォルダを選択
4. オプション設定:
   - ✅ **"Create groups"** を選択
   - ✅ **"Add to targets: TSUMO"** にチェック
   - ❌ **"Copy items if needed"** のチェックを**外す**
5. `Add` をクリック

---

## ステップ3: Firebase SDKの追加（Swift Package Manager）

1. Xcodeのプロジェクトナビゲーターで、プロジェクト名 **"TSUMO"**（一番上の青いアイコン）をクリック
2. プロジェクト設定画面で、**"Package Dependencies"** タブを選択
3. 左下の **"+"** ボタンをクリック
4. 検索フィールドに以下のURLを入力:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
5. `Add Package` をクリック
6. パッケージが読み込まれたら、以下のパッケージを選択:
   - ✅ **FirebaseAuth**
   - ✅ **FirebaseFirestore**
   - ✅ **FirebaseFirestoreSwift**
7. `Add Package` をクリック
8. 追加が完了するまで待つ（数分かかる場合があります）

---

## ステップ4: Bundle Identifierの確認

1. プロジェクト設定画面で、**"TARGETS"** の下の **"TSUMO"** を選択
2. **"General"** タブを選択
3. **"Bundle Identifier"** を確認:
   - 現在の値: `com.tsumo.app`
   - 必要に応じて変更してください（例: `com.yourname.tsumo`）

---

## ステップ5: ビルドして確認

1. Xcodeの上部ツールバーで、シミュレーターまたはデバイスを選択（例: "iPhone 15 Pro"）
2. `Product > Build` を選択（または `Cmd + B`）
3. エラーがないか確認

### エラーが発生した場合

- **"No such module 'FirebaseAuth'"** などのエラー:
  - Firebase SDKの追加が完了していない可能性があります
  - ステップ3を再度実行してください

- **"Cannot find 'XXX' in scope"** などのエラー:
  - ファイルが正しく追加されていない可能性があります
  - ステップ2を再度実行してください

- **"Missing required module 'XXX'"** などのエラー:
  - `Product > Clean Build Folder` を実行（`Shift + Cmd + K`）
  - 再度ビルドしてください

---

## ステップ6: Firebase設定ファイルの追加（後で実行）

Firebaseプロジェクトを作成した後、以下の手順で `GoogleService-Info.plist` を追加:

1. Firebase Consoleで `GoogleService-Info.plist` をダウンロード
2. Xcodeのプロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
3. `Add Files to "TSUMO"...` を選択
4. ダウンロードした `GoogleService-Info.plist` を選択
5. オプション設定:
   - ✅ **"Copy items if needed"** にチェック（Firebaseからダウンロードしたファイルをコピー）
   - ✅ **"Add to targets: TSUMO"** にチェック
6. `Add` をクリック

詳細は `FIREBASE_SETUP.md` を参照してください。

---

## 確認チェックリスト

追加が完了したら、以下を確認してください:

- [ ] Viewsフォルダ内の全てのSwiftファイルがプロジェクトに表示されている
- [ ] ViewModelsフォルダ内の全てのSwiftファイルがプロジェクトに表示されている
- [ ] Servicesフォルダ内のFirebaseService.swiftがプロジェクトに表示されている
- [ ] Utilitiesフォルダ内の全てのSwiftファイルがプロジェクトに表示されている
- [ ] Firebase SDK（FirebaseAuth, FirebaseFirestore, FirebaseFirestoreSwift）が追加されている
- [ ] ビルドエラーがない

---

## トラブルシューティング

### ファイルが表示されない場合

1. プロジェクトナビゲーターで `TSUMO` フォルダを展開して確認
2. ファイルが見つからない場合は、再度ステップ2を実行
3. ファイルが灰色で表示される場合:
   - ファイルを選択して、右側のインスペクターで "Target Membership" を確認
   - "TSUMO" にチェックが入っているか確認

### ビルドエラーが続く場合

1. `Product > Clean Build Folder` を実行
2. Xcodeを再起動
3. 再度ビルド

---

## 次のステップ

ファイル追加が完了したら:

1. Firebaseプロジェクトを作成（`FIREBASE_SETUP.md` を参照）
2. `GoogleService-Info.plist` を追加（ステップ6）
3. アプリを実行して動作確認
