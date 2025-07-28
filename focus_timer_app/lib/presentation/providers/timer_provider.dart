import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/pomodoro_state.dart';
import '../../data/models/settings.dart';
import '../../core/constants/app_constants.dart';
import '../../services/audio_service.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';
import '../../core/utils/responsive_utils.dart';
import '../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  PomodoroState _state;
  Settings _settings;
  final Uuid _uuid = const Uuid();
  bool _hasPlayedSound = false; // 音声再生フラグを追加

  TimerProvider({required Settings settings})
      : _settings = settings,
        _state = PomodoroState(
          remainingSeconds: settings.workDurationSeconds,
          currentSession: SessionType.work,
          status: TimerStatus.initial,
          completedPomodoros: 0,
          totalWorkSeconds: 0,
        );

  PomodoroState get state => _state;
  Settings get settings => _settings;
  bool get isRunning => _state.isRunning;
  bool get isPaused => _state.isPaused;
  bool get isFinished => _state.isFinished;

  void updateSettings(Settings newSettings) {
    _settings = newSettings;
    if (_state.isInitial) {
      _resetToWorkSession();
    }
    notifyListeners();
  }

  void startTimer() {
    if (_state.isRunning) return;

    if (_state.isFinished) {
      _moveToNextSession();
    }

    _state = _state.copyWith(
      status: TimerStatus.running,
      sessionStartTime: DateTime.now(),
    );

    // 音声再生フラグをリセット
    _hasPlayedSound = false;

    _startTimer();
    notifyListeners();
  }

  void pauseTimer() {
    if (!_state.isRunning) return;

    _timer?.cancel();
    // 音声を停止
    AudioService().stopSound();
    // 残り3秒以下の場合は音声再生フラグを設定（スキップ）
    if (_state.remainingSeconds <= 3) {
      _hasPlayedSound = true;
    }
    _state = _state.copyWith(
      status: TimerStatus.paused,
      lastPauseTime: DateTime.now(),
    );
    notifyListeners();
  }

  void resumeTimer() {
    if (!_state.isPaused) return;

    _state = _state.copyWith(
      status: TimerStatus.running,
      lastPauseTime: null,
    );

    _startTimer();
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    // 音声を停止
    AudioService().stopSound();
    // 音声再生フラグをリセット
    _hasPlayedSound = false;
    _resetToWorkSession();
    notifyListeners();
  }

  void skipSession() {
    _timer?.cancel();
    // 音声を停止
    AudioService().stopSound();
    // 音声再生フラグをリセット
    _hasPlayedSound = false;
    _moveToNextSession();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.remainingSeconds <= 0) {
        _completeSession();
      } else {
        // 3.2秒前になったら音声を開始（一回のみ）
        if (_state.remainingSeconds == 3 && !_hasPlayedSound) {
          _startCountdownSound();
          _hasPlayedSound = true; // フラグを設定
        }
        
        _state = _state.copyWith(
          remainingSeconds: _state.remainingSeconds - 1,
        );
        notifyListeners();
      }
    });
  }

  void _startCountdownSound() {
    print('Starting countdown sound at 3.2 seconds remaining...');
    AudioService().playNotificationSound(_settings);
  }

  void _completeSession() {
    _timer?.cancel();
    
    // 音声を停止
    AudioService().stopSound();
    
    // セッション記録を保存
    final sessionRecord = SessionRecord(
      id: _uuid.v4(),
      sessionType: _state.currentSession,
      startTime: _state.sessionStartTime ?? DateTime.now(),
      endTime: DateTime.now(),
      plannedDuration: _getPlannedDuration(_state.currentSession),
      actualDuration: _getPlannedDuration(_state.currentSession) - _state.remainingSeconds,
      wasCompleted: true,
    );

    final updatedHistory = List<SessionRecord>.from(_state.sessionHistory)
      ..add(sessionRecord);

    _state = _state.copyWith(
      status: TimerStatus.finished,
      sessionHistory: updatedHistory,
    );

    // 作業セッションの場合、完了数を増やす
    if (_state.currentSession == SessionType.work) {
      _state = _state.copyWith(
        completedPomodoros: _state.completedPomodoros + 1,
        totalWorkSeconds: _state.totalWorkSeconds + _getPlannedDuration(SessionType.work),
      );
    }

    notifyListeners();

    // 音が鳴り始めていない場合のみ、セッション完了時のアラーム音を鳴らす
    if (!_hasPlayedSound) {
      _playNotification();
    }

    // ポモドーロサイクル完了時（長い休憩に入る直前）だけAI分析を自動実行
    if (_state.currentSession == SessionType.work) {
      // サイクル数はAppConstants.pomodorosBeforeLongBreak
      if ((_state.completedPomodoros + 1) % AppConstants.pomodorosBeforeLongBreak == 0) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          final aiProvider = Provider.of<AIProvider>(context, listen: false);
          final focusPatterns = toFocusPatternList(updatedHistory);
          aiProvider.performFullAnalysis(focusPatterns);
        }
      }
    }

    // 自動開始が有効な場合、次のセッションに進む
    if (_settings.autoStart) {
      Future.delayed(const Duration(seconds: 2), () {
        _moveToNextSession();
        startTimer(); // タイマーも自動で再スタート
      });
    }

    // 音声再生フラグをリセット（次のセッションのため）
    _hasPlayedSound = false;

    saveSessionHistory();
  }

  void _playNotification() async {
    print('TimerProvider: Playing notification...');
    final audioService = AudioService();
    await audioService.playNotificationSound(_settings);
    print('TimerProvider: Notification completed');
  }

  void _moveToNextSession() {
    SessionType nextSession;
    int nextDuration;

    if (_state.currentSession == SessionType.work) {
      // 作業セッションの後
      if (_state.completedPomodoros % AppConstants.pomodorosBeforeLongBreak == 0) {
        // 長い休憩
        nextSession = SessionType.longBreak;
        nextDuration = _settings.longBreakDurationSeconds;
      } else {
        // 短い休憩
        nextSession = SessionType.shortBreak;
        nextDuration = _settings.shortBreakDurationSeconds;
      }
    } else {
      // 休憩セッションの後は作業セッション
      nextSession = SessionType.work;
      nextDuration = _settings.workDurationSeconds;
    }

    _state = _state.copyWith(
      remainingSeconds: nextDuration,
      currentSession: nextSession,
      status: TimerStatus.initial,
      sessionStartTime: null,
      lastPauseTime: null,
    );
  }

  void _resetToWorkSession() {
    _state = _state.copyWith(
      remainingSeconds: _settings.workDurationSeconds,
      currentSession: SessionType.work,
      status: TimerStatus.initial,
      sessionStartTime: null,
      lastPauseTime: null,
    );
  }

  int _getPlannedDuration(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return _settings.workDurationSeconds;
      case SessionType.shortBreak:
        return _settings.shortBreakDurationSeconds;
      case SessionType.longBreak:
        return _settings.longBreakDurationSeconds;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- 追加: 履歴の永続化 ---
  Future<void> loadSessionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('sessionHistory');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<SessionRecord> loaded = jsonList.map((e) => SessionRecord.fromJson(e)).toList();
      _state = _state.copyWith(sessionHistory: loaded);
      notifyListeners();
    }
  }

  Future<void> saveSessionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _state.sessionHistory.map((e) => e.toJson()).toList();
    await prefs.setString('sessionHistory', json.encode(jsonList));
  }

  // --- 追加: 初期化時に履歴を復元 ---
  Future<void> initialize() async {
    await loadSessionHistory();
  }

  // --- 追加: セッション履歴のリセット ---
  Future<void> clearSessionHistory() async {
    _state = _state.copyWith(sessionHistory: []);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionHistory');
  }
} 