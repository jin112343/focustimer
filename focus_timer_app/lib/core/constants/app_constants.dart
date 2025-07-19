class AppConstants {
  // アプリ情報
  static const String appName = 'Focus Timer AI';
  static const String appVersion = '1.0.0';
  
  // デフォルトタイマー設定
  static const int defaultWorkDuration = 25; // 分
  static const int defaultShortBreakDuration = 5; // 分
  static const int defaultLongBreakDuration = 15; // 分
  static const int pomodorosBeforeLongBreak = 4;
  
  // 音声設定
  static const double defaultVolume = 0.7;
  static const List<String> availableSounds = [
    'notification_simple',
    'notification_gentle',
    'notification_energetic',
  ];
  
  // AI設定
  static const int aiAnalysisInterval = 24; // 時間
  static const double minConfidenceScore = 0.7;
  
  // データベース設定
  static const String hiveBoxName = 'focus_timer_data';
  static const String settingsBoxName = 'settings';
  static const String sessionsBoxName = 'sessions';
  static const String aiAnalysisBoxName = 'ai_analysis';
  
  // 通知設定
  static const String notificationChannelId = 'focus_timer_channel';
  static const String notificationChannelName = 'Focus Timer Notifications';
  static const String notificationChannelDescription = 'Focus Timer AI notifications';
  
  // アニメーション設定
  static const Duration timerAnimationDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 150);
  
  // エラーメッセージ
  static const String networkErrorMessage = 'ネットワーク接続を確認してください';
  static const String aiServiceErrorMessage = 'AI機能に一時的な問題が発生しました';
  static const String permissionErrorMessage = '通知の許可が必要です';
} 