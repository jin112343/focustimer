class Settings {
  final int workDurationSeconds; // 秒
  final int shortBreakDurationSeconds; // 秒
  final int longBreakDurationSeconds; // 秒
  final bool soundEnabled;
  final double volume; // 0.0-1.0
  final bool vibrationEnabled;
  final bool autoStart;
  final bool aiEnabled;
  final bool aiSuggestionsEnabled;
  final String preferredLanguage;
  final bool darkModeEnabled;
  final String selectedSound;
  final int vibrationIntensity; // 0-3
  final bool notificationsEnabled;
  final bool showProgressBar;
  final bool showPomodoroCounter;
  final String? themeName; // カラーテーマ名

  const Settings({
    required this.workDurationSeconds,
    required this.shortBreakDurationSeconds,
    required this.longBreakDurationSeconds,
    required this.soundEnabled,
    required this.volume,
    required this.vibrationEnabled,
    required this.autoStart,
    required this.aiEnabled,
    required this.aiSuggestionsEnabled,
    required this.preferredLanguage,
    required this.darkModeEnabled,
    required this.selectedSound,
    required this.vibrationIntensity,
    required this.notificationsEnabled,
    required this.showProgressBar,
    required this.showPomodoroCounter,
    this.themeName,
  });

  Settings copyWith({
    int? workDurationSeconds,
    int? shortBreakDurationSeconds,
    int? longBreakDurationSeconds,
    bool? soundEnabled,
    double? volume,
    bool? vibrationEnabled,
    bool? autoStart,
    bool? aiEnabled,
    bool? aiSuggestionsEnabled,
    String? preferredLanguage,
    bool? darkModeEnabled,
    String? selectedSound,
    int? vibrationIntensity,
    bool? notificationsEnabled,
    bool? showProgressBar,
    bool? showPomodoroCounter,
    String? themeName,
  }) {
    return Settings(
      workDurationSeconds: workDurationSeconds ?? this.workDurationSeconds,
      shortBreakDurationSeconds: shortBreakDurationSeconds ?? this.shortBreakDurationSeconds,
      longBreakDurationSeconds: longBreakDurationSeconds ?? this.longBreakDurationSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      volume: volume ?? this.volume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      autoStart: autoStart ?? this.autoStart,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      aiSuggestionsEnabled: aiSuggestionsEnabled ?? this.aiSuggestionsEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedSound: selectedSound ?? this.selectedSound,
      vibrationIntensity: vibrationIntensity ?? this.vibrationIntensity,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      showPomodoroCounter: showPomodoroCounter ?? this.showPomodoroCounter,
      themeName: themeName ?? this.themeName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDurationSeconds': workDurationSeconds,
      'shortBreakDurationSeconds': shortBreakDurationSeconds,
      'longBreakDurationSeconds': longBreakDurationSeconds,
      'soundEnabled': soundEnabled,
      'volume': volume,
      'vibrationEnabled': vibrationEnabled,
      'autoStart': autoStart,
      'aiEnabled': aiEnabled,
      'aiSuggestionsEnabled': aiSuggestionsEnabled,
      'preferredLanguage': preferredLanguage,
      'darkModeEnabled': darkModeEnabled,
      'selectedSound': selectedSound,
      'vibrationIntensity': vibrationIntensity,
      'notificationsEnabled': notificationsEnabled,
      'showProgressBar': showProgressBar,
      'showPomodoroCounter': showPomodoroCounter,
      'themeName': themeName,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      workDurationSeconds: json['workDurationSeconds'] ?? ((json['workDuration'] ?? 1) * 60),
      shortBreakDurationSeconds: json['shortBreakDurationSeconds'] ?? ((json['shortBreakDuration'] ?? 1) * 60),
      longBreakDurationSeconds: json['longBreakDurationSeconds'] ?? ((json['longBreakDuration'] ?? 1) * 60),
      soundEnabled: json['soundEnabled'] ?? true,
      volume: json['volume'] ?? 0.7,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      autoStart: json['autoStart'] ?? false,
      aiEnabled: json['aiEnabled'] ?? true,
      aiSuggestionsEnabled: json['aiSuggestionsEnabled'] ?? true,
      preferredLanguage: json['preferredLanguage'] ?? 'ja',
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      selectedSound: json['selectedSound'] ?? 'notification_simple',
      vibrationIntensity: json['vibrationIntensity'] ?? 2,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      showProgressBar: json['showProgressBar'] ?? true,
      showPomodoroCounter: json['showPomodoroCounter'] ?? true,
      themeName: json['themeName'],
    );
  }

  factory Settings.defaultSettings() {
    return const Settings(
      workDurationSeconds: 60,
      shortBreakDurationSeconds: 60,
      longBreakDurationSeconds: 60,
      soundEnabled: true,
      volume: 0.7,
      vibrationEnabled: true,
      autoStart: false,
      aiEnabled: true,
      aiSuggestionsEnabled: true,
      preferredLanguage: 'ja',
      darkModeEnabled: false,
      selectedSound: 'notification_simple',
      vibrationIntensity: 2,
      notificationsEnabled: true,
      showProgressBar: true,
      showPomodoroCounter: true,
      themeName: 'オーシャン',
    );
  }

  // 互換用: 分単位getter
  int get workDuration => workDurationSeconds ~/ 60;
  int get shortBreakDuration => shortBreakDurationSeconds ~/ 60;
  int get longBreakDuration => longBreakDurationSeconds ~/ 60;

  // 設定の妥当性チェック
  bool get isValid {
    return workDuration > 0 &&
           shortBreakDuration > 0 &&
           longBreakDuration > 0 &&
           volume >= 0.0 &&
           volume <= 1.0 &&
           vibrationIntensity >= 0 &&
           vibrationIntensity <= 3;
  }

  // デフォルト設定との差分
  bool get hasCustomSettings {
    return workDurationSeconds != 60 ||
           shortBreakDurationSeconds != 60 ||
           longBreakDurationSeconds != 60 ||
           !soundEnabled ||
           volume != 0.7 ||
           !vibrationEnabled ||
           autoStart ||
           !aiEnabled ||
           !aiSuggestionsEnabled ||
           preferredLanguage != 'ja' ||
           darkModeEnabled ||
           selectedSound != 'notification_simple' ||
           vibrationIntensity != 2 ||
           !notificationsEnabled ||
           !showProgressBar ||
           !showPomodoroCounter;
  }
} 