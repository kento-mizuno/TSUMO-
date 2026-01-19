# クリーンなファイル追加手順

## 推奨手順：空のフォルダを先に削除

空のフォルダグループを先に削除してから、正しい設定でファイルを追加する方がクリーンです。

---

## ステップ1: 空のフォルダグループを削除

以下のフォルダが空で表示されている場合、削除してください：

1. **ViewModels** フォルダ（空の場合）
2. **Services** フォルダ（空の場合）
3. **Utilities** フォルダ（空の場合）

### 削除方法

1. プロジェクトナビゲーターで、**空のフォルダ**を選択
2. **右クリック** → `Delete` を選択
3. 確認ダイアログで **"Remove Reference"** を選択
   - 重要: **"Move to Trash"** ではなく **"Remove Reference"** を選んでください
   - これでプロジェクトから参照が削除されますが、実際のファイルは残ります

---

## ステップ2: 正しい設定でファイルを追加

空のフォルダを削除したら、以下の手順でファイルを追加してください。

### 2-1. ViewModelsフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/ViewModels` フォルダを選択
4. ダイアログで設定:
   - **Action**: **"Reference files in place"** を選択
   - **Targets**: **"TSUMO"** にチェック
   - **Groups**: "Create groups"（通常は自動）
5. `Finish` をクリック

### 2-2. Servicesフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/Services` フォルダを選択
4. ダイアログで設定:
   - **Action**: **"Reference files in place"** を選択
   - **Targets**: **"TSUMO"** にチェック
   - **Groups**: "Create groups"（通常は自動）
5. `Finish` をクリック

### 2-3. Utilitiesフォルダの追加

1. プロジェクトナビゲーターで `TSUMO` フォルダを**右クリック**
2. `Add Files to "TSUMO"...` を選択
3. `/Users/TSUMO!/TSUMO/Utilities` フォルダを選択
4. ダイアログで設定:
   - **Action**: **"Reference files in place"** を選択
   - **Targets**: **"TSUMO"** にチェック
   - **Groups**: "Create groups"（通常は自動）
5. `Finish` をクリック

---

## 確認方法

各フォルダを展開して、以下のファイルが表示されることを確認してください：

### ViewModels（9ファイル）
- AuthViewModel.swift
- FreeMahjongViewModel.swift
- GroupsViewModel.swift
- MatchHistoryViewModel.swift
- MonthlySummaryViewModel.swift
- MyPageViewModel.swift
- RankingViewModel.swift
- RulesSettingViewModel.swift
- ScoreInputViewModel.swift

### Services（1ファイル）
- FirebaseService.swift

### Utilities（2ファイル）
- DateFormatter+Extensions.swift
- ScoreCalculator.swift

---

## この方法のメリット

1. **重複を避けられる**: 空のフォルダ参照と正しいグループが混在しない
2. **整理しやすい**: プロジェクトナビゲーターがクリーンになる
3. **エラーを防げる**: 正しい設定で追加するため、後で問題が起きにくい

---

## 注意点

- 空のフォルダを削除しても、実際のファイル（`TSUMO/ViewModels/` など）は削除されません
- "Remove Reference" を選択することで、プロジェクトからの参照だけが削除されます
- 削除後、すぐに正しい設定で追加し直してください
