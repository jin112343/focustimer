# Focus Timer AI

次世代ポモドーロ集中タイマー with Gemini AI


<img width="132" height="286" alt="Simulator Screenshot - iPhone 16 Pro - 2025-07-28 at 23 39 04" src="https://github.com/user-attachments/assets/4fb26f9e-1abc-4cd5-acfb-1bc5ded80685" />
<img width="132" height="286" alt="Simulator Screenshot - iPhone 16 Pro - 2025-07-28 at 23 39 53" src="https://github.com/user-attachments/assets/c138cda4-d281-447a-ae5d-8ffc0666c3c2" />
<img width="132" height="286" alt="Simulator Screenshot - iPhone 16 Pro - 2025-07-28 at 23 39 48" src="https://github.com/user-attachments/assets/407308bd-2a18-4ab5-8f6a-de4b5ff8f6e1" />



## 概要

Focus Timer AIは、Google Gemini AIを活用した次世代のポモドーロタイマーアプリです。ユーザーの集中パターンを分析し、個人化されたアドバイスを提供することで、より効果的な時間管理をサポートします。

## 主な機能

### 🧠 AI分析機能
- **集中パターン分析**: ユーザーの作業セッションを分析し、最適な時間帯を特定
- **個人化されたアドバイス**: AIが学習したパターンに基づいてカスタマイズされた提案
- **生産性スコア**: 継続的な改善を追跡する生産性指標
- **最適タイミング予測**: 最も集中できる時間帯を予測

### ⏰ タイマー機能
- **ポモドーロテクニック**: 25分作業 + 5分休憩の標準的なポモドーロサイクル
- **カスタマイズ可能**: 作業時間、休憩時間を自由に設定
- **視覚的フィードバック**: 美しい円形タイマーで残り時間を表示
- **音声・振動通知**: セッション終了時の通知

### 📊 統計・分析
- **詳細な統計**: 日別・週別・月別の集中時間
- **パターン分析**: 時間帯別の生産性分析
- **進捗追跡**: 目標達成率と継続日数の記録

### 🎨 モダンUI
- **Material Design 3**: 最新のデザインシステム
- **ダークモード対応**: 目に優しいダークテーマ
- **アニメーション**: スムーズなアニメーション効果
- **レスポンシブデザイン**: 様々な画面サイズに対応

## 技術スタック

### フロントエンド
- **Flutter**: クロスプラットフォーム開発
- **Dart**: プログラミング言語
- **Provider**: 状態管理
- **Google Fonts**: タイポグラフィ

### AI・バックエンド
- **Google Gemini AI**: 自然言語処理・分析
- **Google Generative AI**: AI API統合
- **Hive**: ローカルデータベース
- **Shared Preferences**: 設定保存

### 音声・通知
- **AudioPlayers**: 音声再生
- **Vibration**: 振動通知

### チャート・UI
- **FL Chart**: データ可視化
- **Lottie**: アニメーション
- **Percent Indicator**: 進捗表示

## セットアップ

### 前提条件
- Flutter SDK 3.8.1以上
- Dart SDK
- Android Studio / VS Code
- Git

### インストール手順

1. **リポジトリのクローン**
```bash
git clone https://github.com/yourusername/focus-timer-ai.git
cd focus-timer-ai
```

2. **依存関係のインストール**
```bash
flutter pub get
```

3. **環境変数の設定**
```bash
# .envファイルを作成
cp .env.example .env
# Gemini APIキーを設定
```

4. **アプリの実行**
```bash
flutter run
```

### 環境変数

`.env`ファイルに以下の設定が必要です：

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

## プロジェクト構造

```
focus_timer_app/
├── lib/
│   ├── core/
│   │   ├── constants/     # 定数・設定
│   │   ├── errors/        # エラーハンドリング
│   │   └── utils/         # ユーティリティ
│   ├── data/
│   │   ├── models/        # データモデル
│   │   ├── repositories/  # リポジトリ
│   │   └── datasources/   # データソース
│   ├── domain/
│   │   ├── entities/      # エンティティ
│   │   ├── repositories/  # リポジトリインターフェース
│   │   └── usecases/      # ユースケース
│   ├── presentation/
│   │   ├── screens/       # 画面
│   │   ├── widgets/       # ウィジェット
│   │   ├── providers/     # 状態管理
│   │   └── theme/         # テーマ
│   └── services/          # 外部サービス
├── assets/
│   ├── animations/        # Lottieアニメーション
│   ├── images/           # 画像
│   └── sounds/           # 音声ファイル
└── test/                 # テスト
```

## 開発ガイドライン

### コーディング規約
- **Dart**: Effective Dartガイドラインに従う
- **命名規則**: snake_case（変数・関数）、PascalCase（クラス）
- **コメント**: 日本語で分かりやすく記述
- **エラーハンドリング**: 適切な例外処理を実装

### アーキテクチャ
- **Clean Architecture**: レイヤー分離による保守性向上
- **Repository Pattern**: データアクセスの抽象化
- **Provider Pattern**: 状態管理の一元化

### テスト
```bash
# ユニットテスト
flutter test

# ウィジェットテスト
flutter test test/widget_test.dart

# カバレッジ
flutter test --coverage
```

## デプロイ

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 貢献

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 作者

- **jin mizoi** - *Initial work* - [GitHub](https://github.com/jin112343)

## 謝辞

- [Flutter](https://flutter.dev/) - クロスプラットフォーム開発フレームワーク
- [Google Gemini AI](https://ai.google.dev/) - AI分析機能
- [Material Design](https://material.io/) - デザインシステム

## 更新履歴

### v1.0.0 (2024-01-XX)
- 初回リリース
- 基本的なポモドーロタイマー機能
- AI分析機能の実装
- モダンUIの実装 
