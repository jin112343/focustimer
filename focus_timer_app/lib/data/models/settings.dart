class Settings {
  final int workDuration; // 分
  final int shortBreakDuration; // 分
  final int longBreakDuration; // 分
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

  const Settings({
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
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
  });

  Settings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
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
  }) {
    return Settings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
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
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      workDuration: json['workDuration'] ?? 25,
      shortBreakDuration: json['shortBreakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
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
    );
  }

  factory Settings.defaultSettings() {
    return const Settings(
      workDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
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
    );
  }

  // 時間を秒に変換
  int get workDurationSeconds => workDuration * 60;
  int get shortBreakDurationSeconds => shortBreakDuration * 60;
  int get longBreakDurationSeconds => longBreakDuration * 60;

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
    return workDuration != 25 ||
           shortBreakDuration != 5 ||
           longBreakDuration != 15 ||
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