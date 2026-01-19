# TSUMO! - 麻雀スコア管理アプリ

## プロジェクト概要

iOS用の麻雀スコア管理アプリです。グループ対戦と個人記録（フリー麻雀）の両方をサポートします。

## 技術スタック

- **フレームワーク**: SwiftUI
- **バックエンド**: Firebase (Firestore, Authentication)
- **最小iOSバージョン**: iOS 15.0+
- **アーキテクチャ**: MVVM

## プロジェクト構造

```
TSUMO/
├── Models/           # データモデル
├── Views/           # SwiftUIビュー
├── ViewModels/      # ビューモデル
├── Services/        # Firebaseサービス層
├── Utilities/       # ユーティリティ
└── Resources/       # アセット、ローカライズ
```

## セットアップ手順

1. Xcodeでプロジェクトを開く
2. Firebaseプロジェクトを作成
3. `GoogleService-Info.plist`をプロジェクトに追加
4. Firebase SDKをインストール（Swift Package ManagerまたはCocoaPods）

## 主要機能

- 認証（Apple Sign In、Email認証）
- グループ管理
- ゲーム入力とスコア計算
- 統計表示（マイページ、月次サマリー）
- ランキング表示
- 対戦履歴
- フリー麻雀（個人記録）
