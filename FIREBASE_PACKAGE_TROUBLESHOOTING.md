# FirebaseFirestoreSwiftが見つからない場合

## 状況

Firebase SDKのパッケージ選択画面で、`FirebaseFirestoreSwift`が表示されない場合の対処法です。

---

## 解決方法

### 方法1: スクロールして探す

1. パッケージリストを**下にスクロール**してください
2. `FirebaseFirestoreSwift`はリストの後半に表示される可能性があります
3. アルファベット順で並んでいる場合、「Swift」で始まるため、後半にあります

### 方法2: FirebaseFirestoreに含まれている可能性

`FirebaseFirestoreSwift`は、`FirebaseFirestore`の依存関係として自動的に含まれる場合があります。

**確認方法:**
- `FirebaseFirestore`を追加した後、ビルドして確認
- エラーが出ない場合は、既に含まれています

### 方法3: 必須ではない可能性

実際には、`FirebaseFirestoreSwift`は必須ではありません。以下の2つだけでも動作します：

- ✅ **FirebaseAuth**
- ✅ **FirebaseFirestore**

`FirebaseFirestoreSwift`は、FirestoreのSwift用拡張機能ですが、なくてもコードは動作します。

---

## 推奨される選択

### 最低限必要なパッケージ

1. **FirebaseAuth** → Add to Target: **TSUMO**
2. **FirebaseFirestore** → Add to Target: **TSUMO**

この2つを選択して「Add Package」をクリックしてください。

### FirebaseFirestoreSwiftについて

- 見つからない場合は、後で追加することもできます
- または、`FirebaseFirestore`を追加すると自動的に含まれる場合があります
- コードで`import FirebaseFirestoreSwift`が必要な場合は、後で追加してください

---

## 次のステップ

1. **FirebaseAuth**と**FirebaseFirestore**の2つを選択
2. 両方の「Add to Target」を「TSUMO」に設定
3. 「Add Package」をクリック
4. ビルドして確認
5. もし`FirebaseFirestoreSwift`が必要な場合は、後で追加

---

## 後でFirebaseFirestoreSwiftを追加する方法

もし後で必要になった場合：

1. プロジェクトナビゲーターで青いアイコンの「TSUMO」を選択
2. 「Package Dependencies」タブを選択
3. `firebase-ios-sdk`パッケージを右クリック
4. 「Update to Latest Version」を選択
5. 再度パッケージ選択画面で`FirebaseFirestoreSwift`を探す
