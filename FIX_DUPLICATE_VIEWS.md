# Viewsフォルダが2つ表示される問題の解決方法

## 問題の説明

Xcodeでファイルを追加する際に「Create folder references」を選択してしまったため、Viewsフォルダが2つ表示されています：

1. **Views**（グループ）- 正しい方。ファイルが入っている
2. **Views**（フォルダ参照）- 空の方。削除が必要

## 解決方法

### ステップ1: 空のViewsフォルダ参照を削除

1. Xcodeのプロジェクトナビゲーターで、**空のViewsフォルダ**（フォルダ参照の方）を選択
2. **右クリック**して `Delete` を選択
3. 確認ダイアログで **"Remove Reference"** を選択（**"Move to Trash"** ではない）
   - これでプロジェクトから参照が削除されますが、実際のファイルは残ります

### ステップ2: 正しいViewsグループを確認

1. プロジェクトナビゲーターで、**正しいViewsフォルダ**（ファイルが入っている方）を展開
2. 以下のフォルダが表示されることを確認:
   - Authentication/
   - FreeMahjong/
   - Game/
   - Groups/
   - Home/
   - MatchHistory/
   - MyPage/
   - Ranking/
   - Splash/
   - Statistics/

### ステップ3: ビルドして確認

1. `Product > Build`（または `Cmd + B`）
2. エラーがないか確認

## 確認方法

正しいViewsグループには以下のファイルが含まれているはずです：

- Views/Authentication/SignInView.swift
- Views/FreeMahjong/FreeMahjongView.swift
- Views/Game/GameDetailView.swift
- Views/Game/GameTypeSelectionView.swift
- Views/Game/RulesSettingView.swift
- Views/Game/ScoreInputView.swift
- Views/Groups/CreateGroupView.swift
- Views/Groups/GroupDetailView.swift
- Views/Groups/GroupsView.swift
- Views/Home/HomeView.swift
- Views/MatchHistory/MatchHistoryView.swift
- Views/MyPage/MyPageView.swift
- Views/Ranking/RankingView.swift
- Views/Splash/SplashView.swift
- Views/Statistics/MonthlySummaryView.swift

合計15個のSwiftファイルが表示されていれば正しく追加されています。

## 他のフォルダでも同じ問題が発生した場合

ViewModels、Services、Utilitiesフォルダでも同じ問題が発生している可能性があります。

### 確認方法

各フォルダを展開して、ファイルが表示されているか確認してください：

- **ViewModels**: 9個のSwiftファイル
- **Services**: 1個のSwiftファイル（FirebaseService.swift）
- **Utilities**: 2個のSwiftファイル（DateFormatter+Extensions.swift, ScoreCalculator.swift）

### 対処方法

空のフォルダ参照があれば、同じ手順で削除してください：
1. 空のフォルダ参照を選択
2. 右クリック > Delete
3. "Remove Reference" を選択

## 今後の注意点

ファイルを追加する際は、必ず以下の設定を選択してください：

- ✅ **"Create groups"** を選択（"Create folder references" ではない）
- ✅ **"Add to targets: TSUMO"** にチェック
- ❌ **"Copy items if needed"** のチェックを外す

## トラブルシューティング

### 削除できない場合

1. Xcodeを再起動
2. 再度削除を試みる

### 正しいViewsグループが見つからない場合

1. プロジェクトナビゲーターで `TSUMO` フォルダを展開
2. Viewsフォルダを探す
3. ファイルが入っている方を確認

### ビルドエラーが出る場合

1. `Product > Clean Build Folder`（`Shift + Cmd + K`）
2. Xcodeを再起動
3. 再度ビルド
