import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/pomodoro_state.dart';
import '../../data/models/settings.dart';
import '../../core/constants/app_constants.dart';
import '../../services/audio_service.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  PomodoroState _state;
  Settings _settings;
  final Uuid _uuid = const Uuid();

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

    _state = _state.copyWith(
      status: TimerStatus.running,
      sessionStartTime: DateTime.now(),
    );

    _startTimer();
    notifyListeners();
  }

  void pauseTimer() {
    if (!_state.isRunning) return;

    _timer?.cancel();
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
    _resetToWorkSession();
    notifyListeners();
  }

  void skipSession() {
    _timer?.cancel();
    _moveToNextSession();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.remainingSeconds <= 1) {
        _completeSession();
      } else {
        _state = _state.copyWith(
          remainingSeconds: _state.remainingSeconds - 1,
        );
        notifyListeners();
      }
    });
  }

  void _completeSession() {
    _timer?.cancel();
    
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

    // 音声・バイブレーション通知
    _playNotification();

    // 自動開始が有効な場合、次のセッションに進む
    if (_settings.autoStart) {
      Future.delayed(const Duration(seconds: 2), () {
        _moveToNextSession();
        notifyListeners();
      });
    }
  }

  void _playNotification() async {
    final audioService = AudioService();
    await audioService.playNotificationSound(_settings);
    await audioService.vibrate(_settings);
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
} 