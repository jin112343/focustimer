// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Focus Timer AI';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観設定';

  @override
  String get timerSettings => 'タイマー設定';

  @override
  String get soundAndNotifications => '音声・通知設定';

  @override
  String get aiFeatures => 'AI機能設定';

  @override
  String get others => 'その他';

  @override
  String get language => '言語';

  @override
  String get version => 'バージョン';

  @override
  String get feedback => 'フィードバック送信';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get resetToDefault => 'デフォルト設定に戻す';

  @override
  String get autoStart => '自動開始';

  @override
  String get alarmSound => 'アラーム音';

  @override
  String get volume => '音量';

  @override
  String get dataCollection => 'データ収集';

  @override
  String get dataCollectionDescription => 'データは匿名化され、個人を特定できない形で処理されます';

  @override
  String get cancel => 'キャンセル';

  @override
  String get reset => 'リセット';

  @override
  String get confirmReset => 'すべての設定をデフォルトに戻しますか？';

  @override
  String get aiAnalysis => 'AI分析';

  @override
  String get aiSuggestion => 'AI提案';

  @override
  String get seeFullAIAnalysis => '完全なAI分析を見る';

  @override
  String get close => '閉じる';

  @override
  String get aiInsights => 'AIインサイト';

  @override
  String get noData => 'データがありません';

  @override
  String get feedbackSubtitle => 'アプリ改善のためご意見をお聞かせください';

  @override
  String get privacyPolicySubtitle => 'データの取り扱いについて';

  @override
  String get analytics => '統計・分析';

  @override
  String get analysisDescription => 'あなたの集中パターンを分析した結果です';

  @override
  String get today => '今日';

  @override
  String get thisWeek => '今週';

  @override
  String get thisMonth => '今月';

  @override
  String get resetAnalyticsData => '統計・グラフのデータをリセット';

  @override
  String get resetDataConfirm => 'データリセット確認';

  @override
  String get resetDataWarning => '統計・グラフの全データを本当にリセットしますか？この操作は元に戻せません。';

  @override
  String get resetDataDone => '統計・グラフのデータをリセットしました';

  @override
  String get aiAnalyzing => 'AI分析中...';

  @override
  String get aiWaiting => 'AI待機中';

  @override
  String get noAIData => 'AI分析データがありません';

  @override
  String get aiRefresh => 'AI再分析';

  @override
  String bestFocusTime(Object time) {
    return '今日は$timeが最も集中できる時間です';
  }

  @override
  String get aiDetailAnalysis => 'AI詳細分析';

  @override
  String get todayOptimalTiming => '今日の最適タイミング';

  @override
  String todayOptimalTimingDescription(Object end, Object start) {
    return 'あなたの過去のデータを分析した結果、$start〜$endが最も集中できる時間帯です。重要なタスクはこの時間帯に配置することをお勧めします。';
  }

  @override
  String get confidenceLevel => '信頼度';

  @override
  String confidenceLevelDescription(Object confidence) {
    return 'この分析の信頼度は$confidence%です。';
  }

  @override
  String get recommendedAction => '推奨アクション';

  @override
  String get noAIRecommendedAction => 'AIによる推奨アクションはありません';

  @override
  String get otherAIInsights => 'その他のAIインサイト';

  @override
  String get seeFullAIReport => '完全なAI分析を見る';

  @override
  String get ai => 'AI';

  @override
  String get work => '作業';

  @override
  String get shortBreak => '短い休憩';

  @override
  String get longBreak => '長い休憩';

  @override
  String get personalizedAdvice => '個人化されたアドバイス';

  @override
  String get aiAnalysisResult => 'AI分析結果';

  @override
  String lastUpdated(Object time) {
    return '最終更新: $time';
  }

  @override
  String get noAnalysisData => '分析データがありません';

  @override
  String get optimalTimingPrediction => '最適タイミング予測';

  @override
  String get recommendedSchedule => '推奨スケジュール:';

  @override
  String predictedSessions(Object count) {
    return '予想完了セッション: $count';
  }

  @override
  String get habitFormationProgress => '習慣形成の進捗';

  @override
  String consecutiveUsage(Object days) {
    return '連続使用: $days日';
  }

  @override
  String weeklyGoalAchievement(Object percent) {
    return '週間目標達成率: $percent%';
  }

  @override
  String nextMilestone(Object milestone, Object remaining) {
    return '次のマイルストーン: 連続$milestone日使用まで あと$remaining日';
  }

  @override
  String get actionableActions => '実行可能なアクション:';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours時間前';
  }

  @override
  String daysAgo(Object days) {
    return '$days日前';
  }

  @override
  String timerDisplay(Object minutes, Object seconds) {
    return 'タイマー表示、残り時間$minutes:$seconds';
  }

  @override
  String get currentSessionRemainingTime => '現在のセッションの残り時間を表示しています';

  @override
  String concentrationTrend(Object period) {
    return '集中度の推移（$period単位）';
  }

  @override
  String noConcentrationData(Object period) {
    return '$period単位の集中度グラフを表示できる本物のAI分析データがありません';
  }
}
