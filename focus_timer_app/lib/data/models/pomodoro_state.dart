import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

enum SessionType { work, shortBreak, longBreak }
enum TimerStatus { initial, running, paused, finished }

class PomodoroState {
  final int remainingSeconds;
  final SessionType currentSession;
  final TimerStatus status;
  final int completedPomodoros;
  final int totalWorkSeconds;
  final DateTime? sessionStartTime;
  final DateTime? lastPauseTime;
  final List<SessionRecord> sessionHistory;

  const PomodoroState({
    required this.remainingSeconds,
    required this.currentSession,
    required this.status,
    required this.completedPomodoros,
    required this.totalWorkSeconds,
    this.sessionStartTime,
    this.lastPauseTime,
    this.sessionHistory = const [],
  });

  PomodoroState copyWith({
    int? remainingSeconds,
    SessionType? currentSession,
    TimerStatus? status,
    int? completedPomodoros,
    int? totalWorkSeconds,
    DateTime? sessionStartTime,
    DateTime? lastPauseTime,
    List<SessionRecord>? sessionHistory,
  }) {
    return PomodoroState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentSession: currentSession ?? this.currentSession,
      status: status ?? this.status,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      totalWorkSeconds: totalWorkSeconds ?? this.totalWorkSeconds,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      lastPauseTime: lastPauseTime ?? this.lastPauseTime,
      sessionHistory: sessionHistory ?? this.sessionHistory,
    );
  }

  String get sessionTypeText {
    switch (currentSession) {
      case SessionType.work:
        return '作業中';
      case SessionType.shortBreak:
        return '短い休憩';
      case SessionType.longBreak:
        return '長い休憩';
    }
  }

  String get statusText {
    switch (status) {
      case TimerStatus.initial:
        return '準備完了';
      case TimerStatus.running:
        return sessionTypeText;
      case TimerStatus.paused:
        return '一時停止';
      case TimerStatus.finished:
        return '完了';
    }
  }

  Color get sessionColor {
    switch (currentSession) {
      case SessionType.work:
        return AppColors.workColor;
      case SessionType.shortBreak:
        return AppColors.shortBreakColor;
      case SessionType.longBreak:
        return AppColors.longBreakColor;
    }
  }

  bool get isWorkSession => currentSession == SessionType.work;
  bool get isBreakSession => currentSession != SessionType.work;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isFinished => status == TimerStatus.finished;
  bool get isInitial => status == TimerStatus.initial;

  int get remainingMinutes => remainingSeconds ~/ 60;
  int get remainingSecondsDisplay => remainingSeconds % 60;
  
  String get formattedTime {
    return '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSecondsDisplay.toString().padLeft(2, '0')}';
  }

  double get progressPercentage {
    final totalSeconds = _getTotalSecondsForSession(currentSession);
    return totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0.0;
  }

  int _getTotalSecondsForSession(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return 25 * 60; // 25分
      case SessionType.shortBreak:
        return 5 * 60; // 5分
      case SessionType.longBreak:
        return 15 * 60; // 15分
    }
  }
}

class SessionRecord {
  final String id;
  final SessionType sessionType;
  final DateTime startTime;
  final DateTime? endTime;
  final int plannedDuration; // 秒
  final int actualDuration; // 秒
  final bool wasCompleted;
  final int interruptions;
  final String? notes;

  const SessionRecord({
    required this.id,
    required this.sessionType,
    required this.startTime,
    this.endTime,
    required this.plannedDuration,
    required this.actualDuration,
    required this.wasCompleted,
    this.interruptions = 0,
    this.notes,
  });

  Duration get duration => Duration(seconds: actualDuration);
  bool get isWorkSession => sessionType == SessionType.work;
  double get completionRate => plannedDuration > 0 ? actualDuration / plannedDuration : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionType': sessionType.index,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'plannedDuration': plannedDuration,
      'actualDuration': actualDuration,
      'wasCompleted': wasCompleted,
      'interruptions': interruptions,
      'notes': notes,
    };
  }

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      id: json['id'],
      sessionType: SessionType.values[json['sessionType']],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      plannedDuration: json['plannedDuration'],
      actualDuration: json['actualDuration'],
      wasCompleted: json['wasCompleted'],
      interruptions: json['interruptions'] ?? 0,
      notes: json['notes'],
    );
  }
} 