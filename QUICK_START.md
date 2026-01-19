# クイックスタートガイド

## 今すぐ実行すべき手順（順番通りに）

### ✅ ステップ1: Xcodeでファイルを追加（必須・手動）

**所要時間: 約5分**

1. Xcodeを開く
2. `File > Open` で `/Users/TSUMO!/TSUMO.xcodeproj` を開く
3. プロジェクトナビゲーターで `TSUMO` フォルダを右クリック
4. `Add Files to "TSUMO"...` を選択
5. 以下のフォルダを**1つずつ**追加:
   - `TSUMO/Views` フォルダ
   - `TSUMO/ViewModels` フォルダ
   - `TSUMO/Services` フォルダ
   - `TSUMO/Utilities` フォルダ
   
   **各フォルダ追加時の設定:**
   - ✅ "Create groups" を選択
   - ✅ "Add to targets: TSUMO" にチェック
   - ❌ "Copy items if needed" のチェックを**外す**

詳細は `XCODE_FILE_ADDITION_GUIDE.md` を参照

---

### ✅ ステップ2: Firebase SDKを追加（必須・手動）

**所要時間: 約3分**

1. プロジェクトナビゲーターでプロジェクト名 "TSUMO"（青いアイコン）をクリック
2. "Package Dependencies" タブを選択
3. "+" ボタンをクリック
4. URLを入力: `https://github.com/firebase/firebase-ios-sdk`
5. 以下のパッケージを選択:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseFirestoreSwift
6. "Add Package" をクリック

---

### ✅ ステップ3: ビルドして確認（必須）

**所要時間: 約1分**

1. `Product > Build`（または `Cmd + B`）
2. エラーがないか確認
3. エラーがあれば `XCODE_FILE_ADDITION_GUIDE.md` のトラブルシューティングを参照

---

### ⏭️ ステップ4: Firebase設定（後で実行）

**所要時間: 約10分**

Firebaseプロジェクトを作成して `GoogleService-Info.plist` を追加します。

詳細は `FIREBASE_SETUP.md` を参照してください。

**注意**: このステップは後で実行しても問題ありません。まずはアプリがビルドできることを確認してください。

---

## 手動作業が必要な項目まとめ

| 項目 | 手動/自動 | 所要時間 | 優先度 |
|------|----------|----------|--------|
| Xcodeプロジェクトにファイル追加 | **手動** | 5分 | 🔴 高 |
| Firebase SDK追加 | **手動** | 3分 | 🔴 高 |
| ビルド確認 | **手動** | 1分 | 🔴 高 |
| Firebase設定 | **手動** | 10分 | 🟡 中 |

---

## よくある質問

### Q: ファイルを追加する順番は重要ですか？
A: いいえ、順番は関係ありません。ただし、1つずつ確実に追加することをお勧めします。

### Q: "Copy items if needed" にチェックを入れてしまった
A: 問題ありません。ただし、ファイルが重複する可能性があるので、プロジェクトナビゲーターで確認してください。

### Q: ビルドエラーが出る
A: `XCODE_FILE_ADDITION_GUIDE.md` の「トラブルシューティング」セクションを参照してください。

### Q: Firebase SDKを追加する前にビルドしてもいい？
A: はい、できます。ただし、Firebase関連のエラーが出る可能性があります。まずはファイル追加とビルド確認を完了させてください。

---

## 完了後の確認

以下の項目が全て完了していればOKです:

- [ ] Viewsフォルダ内のファイルがプロジェクトに表示されている
- [ ] ViewModelsフォルダ内のファイルがプロジェクトに表示されている
- [ ] Servicesフォルダ内のファイルがプロジェクトに表示されている
- [ ] Utilitiesフォルダ内のファイルがプロジェクトに表示されている
- [ ] Firebase SDKが追加されている（Package Dependenciesに表示）
- [ ] ビルドエラーがない
