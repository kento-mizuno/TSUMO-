# Package Dependenciesタブの見つけ方

## 問題

「Package Dependencies」タブが見つからない場合の対処法です。

---

## 確認ポイント

### 1. 正しいアイコンを選択しているか確認

Xcodeのプロジェクトナビゲーターには2つの「TSUMO」があります：

1. **プロジェクト（青いアイコン）** - これが正しい
   - アイコン: 青い背景に白いハンマーとレンチ
   - これを選択すると、上部にタブが表示されます

2. **ターゲット（白いアイコン）** - これは違う
   - アイコン: 白い背景に青いアイコン
   - これを選択すると、「General」タブなどが表示されますが、「Package Dependencies」は表示されません

### 2. プロジェクトアイコンを選択する

1. プロジェクトナビゲーターの一番上にある**青いアイコン**の「TSUMO」をクリック
2. 上部に以下のタブが表示されるはずです：
   - **General**
   - **Signing & Capabilities**
   - **Resource Tags**
   - **Info**
   - **Build Settings**
   - **Build Phases**
   - **Build Rules**
   - **Package Dependencies** ← これ！

### 3. タブが表示されない場合

もしタブが表示されない場合：

1. プロジェクトナビゲーターで、一番上の**青いアイコン**の「TSUMO」をクリック
2. 右側のパネルが表示されない場合：
   - Xcodeのメニューから `View > Navigators > Show Project Navigator` を確認
   - 右側のパネルを表示: `View > Inspectors > Show File Inspector`（または `Cmd + Option + 1`）

### 4. 別の方法：メニューから追加

「Package Dependencies」タブが見つからない場合、メニューから直接追加することもできます：

1. Xcodeのメニューバーから `File > Add Package Dependencies...` を選択
2. または、プロジェクトナビゲーターで「TSUMO」（青いアイコン）を右クリック → `Add Package Dependencies...`

---

## 正しい手順（再確認）

### ステップ1: プロジェクトを選択

1. プロジェクトナビゲーターの一番上にある**青いアイコン**の「TSUMO」をクリック
   - 白いアイコンの「TSUMO」（ターゲット）ではないことに注意

### ステップ2: Package Dependenciesタブを選択

1. 上部のタブから **"Package Dependencies"** を選択
2. 左下に **"+"** ボタンが表示されます

### ステップ3: パッケージを追加

1. **"+"** ボタンをクリック
2. URLを入力: `https://github.com/firebase/firebase-ios-sdk`
3. `Add Package` をクリック
4. パッケージを選択:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseFirestoreSwift
5. `Add Package` をクリック

---

## トラブルシューティング

### タブが全く表示されない場合

1. Xcodeを再起動
2. プロジェクトを再度開く
3. プロジェクトナビゲーターで青いアイコンの「TSUMO」を選択

### 「Add Package Dependencies...」メニューが見つからない場合

Xcodeのバージョンが古い可能性があります。Xcode 11以降が必要です。

### 別の方法：Swift Package Managerを直接使用

ターミナルからも追加できますが、XcodeのUIから追加する方が簡単です。

---

## 確認方法

Package Dependenciesが正しく追加されると：

1. 「Package Dependencies」タブに、追加したパッケージが表示されます
2. プロジェクトナビゲーターに「Package Dependencies」セクションが表示されます
3. ビルド時にエラーが出なくなります
