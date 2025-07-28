class AppConstants {
  // タイマー設定
  static const int defaultWorkDuration = 25; // 分
  static const int defaultShortBreakDuration = 5; // 分
  static const int defaultLongBreakDuration = 15; // 分
  
  // Pomodoro設定
  static const int pomodorosBeforeLongBreak = 4;
  
  // AI設定
  static const int aiAnalysisInterval = 5; // セッション数
  static const int maxInsightsToShow = 3;
  
  // アニメーション設定
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration timerUpdateInterval = Duration(seconds: 1);
  
  // デバッグ設定
  static const bool enableDebugLogs = true;
} 