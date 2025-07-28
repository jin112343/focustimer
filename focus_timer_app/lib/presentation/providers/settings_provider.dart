import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings;
  bool _isLoading = false;

  SettingsProvider({required Settings initialSettings})
      : _settings = initialSettings;

  Settings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('settings');
      
      if (settingsJson != null) {
        final settingsMap = Map<String, dynamic>.from(
          // JSONデコード処理（簡略化）
          _parseSettingsJson(settingsJson),
        );
        _settings = Settings.fromJson(settingsMap);
      }
    } catch (e) {
      // エラーが発生した場合はデフォルト設定を使用
      _settings = Settings.defaultSettings();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = _settings.toJson().toString();
      await prefs.setString('settings', settingsJson);
    } catch (e) {
      // エラーハンドリング
      debugPrint('設定の保存に失敗しました: $e');
    }
  }

  Future<void> updateSettings(Settings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await saveSettings();
  }

  // 個別設定の更新メソッド
  Future<void> updateWorkDuration(int seconds) async {
    if (seconds > 0) {
      _settings = _settings.copyWith(workDurationSeconds: seconds);
      await saveSettings();
      notifyListeners();
    }
  }

  Future<void> updateShortBreakDuration(int seconds) async {
    if (seconds > 0) {
      _settings = _settings.copyWith(shortBreakDurationSeconds: seconds);
      await saveSettings();
      notifyListeners();
    }
  }

  Future<void> updateLongBreakDuration(int seconds) async {
    if (seconds > 0) {
      _settings = _settings.copyWith(longBreakDurationSeconds: seconds);
      await saveSettings();
      notifyListeners();
    }
  }

  Future<void> toggleSound(bool enabled) async {
    _settings = _settings.copyWith(soundEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleAutoStart(bool enabled) async {
    _settings = _settings.copyWith(autoStart: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleAI(bool enabled) async {
    _settings = _settings.copyWith(aiEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleAISuggestions(bool enabled) async {
    _settings = _settings.copyWith(aiSuggestionsEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }



  Future<void> updateSelectedSound(String sound) async {
    _settings = _settings.copyWith(selectedSound: sound);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleProgressBar(bool enabled) async {
    _settings = _settings.copyWith(showProgressBar: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> togglePomodoroCounter(bool enabled) async {
    _settings = _settings.copyWith(showPomodoroCounter: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _settings = Settings.defaultSettings();
    await saveSettings();
    notifyListeners();
  }



  // 簡略化されたJSONパース処理
  Map<String, dynamic> _parseSettingsJson(String jsonString) {
    // 実際の実装では適切なJSONパーサーを使用
    // ここでは簡略化のため空のマップを返す
    return {};
  }
} 