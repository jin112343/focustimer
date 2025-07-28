class Settings {
  final int workDurationSeconds; // 秒
  final int shortBreakDurationSeconds; // 秒
  final int longBreakDurationSeconds; // 秒
  final bool soundEnabled;
  final bool autoStart;
  final bool aiEnabled;
  final bool aiSuggestionsEnabled;
  final String selectedSound;
  final bool notificationsEnabled;
  final bool showProgressBar;
  final bool showPomodoroCounter;
  final bool isPremium; // プレミアム版かどうか
  final String systemSoundType; // iOSシステムサウンドタイプ

  const Settings({
    required this.workDurationSeconds,
    required this.shortBreakDurationSeconds,
    required this.longBreakDurationSeconds,
    required this.soundEnabled,
    required this.autoStart,
    required this.aiEnabled,
    required this.aiSuggestionsEnabled,
    required this.selectedSound,
    required this.notificationsEnabled,
    required this.showProgressBar,
    required this.showPomodoroCounter,
    required this.isPremium,
    required this.systemSoundType,
  });

  Settings copyWith({
    int? workDurationSeconds,
    int? shortBreakDurationSeconds,
    int? longBreakDurationSeconds,
    bool? soundEnabled,
    bool? autoStart,
    bool? aiEnabled,
    bool? aiSuggestionsEnabled,
    String? selectedSound,
    bool? notificationsEnabled,
    bool? showProgressBar,
    bool? showPomodoroCounter,
    bool? isPremium,
    String? systemSoundType,
  }) {
    return Settings(
      workDurationSeconds: workDurationSeconds ?? this.workDurationSeconds,
      shortBreakDurationSeconds: shortBreakDurationSeconds ?? this.shortBreakDurationSeconds,
      longBreakDurationSeconds: longBreakDurationSeconds ?? this.longBreakDurationSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      autoStart: autoStart ?? this.autoStart,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      aiSuggestionsEnabled: aiSuggestionsEnabled ?? this.aiSuggestionsEnabled,
      selectedSound: selectedSound ?? this.selectedSound,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      showPomodoroCounter: showPomodoroCounter ?? this.showPomodoroCounter,
      isPremium: isPremium ?? this.isPremium,
      systemSoundType: systemSoundType ?? this.systemSoundType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDurationSeconds': workDurationSeconds,
      'shortBreakDurationSeconds': shortBreakDurationSeconds,
      'longBreakDurationSeconds': longBreakDurationSeconds,
      'soundEnabled': soundEnabled,
      'autoStart': autoStart,
      'aiEnabled': aiEnabled,
      'aiSuggestionsEnabled': aiSuggestionsEnabled,
      'selectedSound': selectedSound,
      'notificationsEnabled': notificationsEnabled,
      'showProgressBar': showProgressBar,
      'showPomodoroCounter': showPomodoroCounter,
      'isPremium': isPremium,
      'systemSoundType': systemSoundType,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      workDurationSeconds: json['workDurationSeconds'] ?? ((json['workDuration'] ?? 1) * 60),
      shortBreakDurationSeconds: json['shortBreakDurationSeconds'] ?? ((json['shortBreakDuration'] ?? 1) * 60),
      longBreakDurationSeconds: json['longBreakDurationSeconds'] ?? ((json['longBreakDuration'] ?? 1) * 60),
      soundEnabled: json['soundEnabled'] ?? true,
      autoStart: json['autoStart'] ?? false,
      aiEnabled: json['aiEnabled'] ?? true,
      aiSuggestionsEnabled: json['aiSuggestionsEnabled'] ?? true,
      selectedSound: json['selectedSound'] ?? 'notification_simple',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      showProgressBar: json['showProgressBar'] ?? true,
      showPomodoroCounter: json['showPomodoroCounter'] ?? true,
      isPremium: json['isPremium'] ?? false,
      systemSoundType: json['systemSoundType'] ?? 'alert',
    );
  }

  factory Settings.defaultSettings() {
    return const Settings(
      workDurationSeconds: 60,
      shortBreakDurationSeconds: 60,
      longBreakDurationSeconds: 60,
      soundEnabled: true,
      autoStart: false,
      aiEnabled: true,
      aiSuggestionsEnabled: true,
      selectedSound: 'notification_simple',
      notificationsEnabled: true,
      showProgressBar: true,
      showPomodoroCounter: true,
      isPremium: false,
      systemSoundType: 'alert',
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
           longBreakDuration > 0;
  }

  // デフォルト設定との差分
  bool get hasCustomSettings {
    return workDurationSeconds != 60 ||
           shortBreakDurationSeconds != 60 ||
           longBreakDurationSeconds != 60 ||
           !soundEnabled ||
           autoStart ||
           !aiEnabled ||
           !aiSuggestionsEnabled ||
           selectedSound != 'notification_simple' ||
           !notificationsEnabled ||
           !showProgressBar ||
           !showPomodoroCounter;
  }
} 