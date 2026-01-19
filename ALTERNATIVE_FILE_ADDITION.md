# フォルダ参照になってしまう場合の対処法

## 問題

「Reference files in place」と「Create groups」を選択しても、フォルダ参照（小さな矢印）になってしまう場合があります。

## 解決方法：ファイルを個別に選択して追加

フォルダ全体ではなく、フォルダ内のファイルを個別に選択して追加する方法が確実です。

---

## ステップ1: フォルダ参照を削除

1. 小さな矢印が表示されているフォルダを選択
2. 右クリック → `Delete`
3. **"Remove Reference"** を選択

---

## ステップ2: ファイルを個別に選択して追加

### ViewModelsフォルダの場合

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/ViewModels` フォルダを開く
4. **フォルダ内の全てのSwiftファイルを選択**:
   - `Cmd + A` で全選択
   - または、`Cmd + クリック`で個別に選択
   - 以下の9ファイルを選択:
     - AuthViewModel.swift
     - FreeMahjongViewModel.swift
     - GroupsViewModel.swift
     - MatchHistoryViewModel.swift
     - MonthlySummaryViewModel.swift
     - MyPageViewModel.swift
     - RankingViewModel.swift
     - RulesSettingViewModel.swift
     - ScoreInputViewModel.swift
5. ダイアログで設定:
   - **Action**: **"Reference files in place"** を選択
   - **Groups**: **"Create groups"** を選択
   - **Targets**: **"TSUMO"** にチェック
6. `Finish` をクリック

### Servicesフォルダの場合

1. 同じ手順で、`FirebaseService.swift` を選択
2. 設定は同じ（"Reference files in place" + "Create groups"）
3. `Finish` をクリック

### Utilitiesフォルダの場合

1. 同じ手順で、以下の2ファイルを選択:
   - DateFormatter+Extensions.swift
   - ScoreCalculator.swift
2. 設定は同じ（"Reference files in place" + "Create groups"）
3. `Finish` をクリック

---

## 確認方法

正しく追加されると：
- ✅ フォルダアイコンに**小さな矢印がない**
- ✅ フォルダを展開すると、中身のファイルが表示される
- ✅ ファイルをクリックすると、エディタで開ける

---

## なぜこの方法が確実か

- フォルダ全体を追加すると、Xcodeがフォルダ参照として扱う場合がある
- ファイルを個別に選択すると、確実にグループとして追加される
- 「Create groups」を選択することで、フォルダ構造が保持される

---

## 注意点

- ファイルを個別に選択しても、「Create groups」を選択すれば、フォルダ構造（ViewModels/、Services/など）が保持されます
- 各フォルダごとに別々に追加する必要があります
