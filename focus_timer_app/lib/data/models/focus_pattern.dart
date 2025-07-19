import 'package:flutter/material.dart';

class FocusPattern {
  final String id;
  final DateTime timestamp;
  final int plannedDuration;
  final int actualDuration;
  final int interruptions;
  final List<String> interruptionTypes;
  final String taskType;
  final String taskCategory;
  final double environmentNoise;
  final String mood;
  final double energyLevel;
  final double productivityScore;
  final TimeOfDay sessionTime;
  final WeatherCondition? weather;
  final Map<String, dynamic> metadata;

  const FocusPattern({
    required this.id,
    required this.timestamp,
    required this.plannedDuration,
    required this.actualDuration,
    this.interruptions = 0,
    this.interruptionTypes = const [],
    required this.taskType,
    required this.taskCategory,
    this.environmentNoise = 0.0,
    this.mood = 'neutral',
    this.energyLevel = 0.5,
    required this.productivityScore,
    required this.sessionTime,
    this.weather,
    this.metadata = const {},
  });

  Duration get duration => Duration(seconds: actualDuration);
  bool get isWorkSession => taskType == 'work';
  double get completionRate => plannedDuration > 0 ? actualDuration / plannedDuration : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'plannedDuration': plannedDuration,
      'actualDuration': actualDuration,
      'interruptions': interruptions,
      'interruptionTypes': interruptionTypes,
      'taskType': taskType,
      'taskCategory': taskCategory,
      'environmentNoise': environmentNoise,
      'mood': mood,
      'energyLevel': energyLevel,
      'productivityScore': productivityScore,
      'sessionTime': '${sessionTime.hour}:${sessionTime.minute}',
      'weather': weather?.toJson(),
      'metadata': metadata,
    };
  }

  factory FocusPattern.fromJson(Map<String, dynamic> json) {
    return FocusPattern(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      plannedDuration: json['plannedDuration'],
      actualDuration: json['actualDuration'],
      interruptions: json['interruptions'] ?? 0,
      interruptionTypes: List<String>.from(json['interruptionTypes'] ?? []),
      taskType: json['taskType'],
      taskCategory: json['taskCategory'],
      environmentNoise: json['environmentNoise']?.toDouble() ?? 0.0,
      mood: json['mood'] ?? 'neutral',
      energyLevel: json['energyLevel']?.toDouble() ?? 0.5,
      productivityScore: json['productivityScore']?.toDouble() ?? 0.0,
      sessionTime: _parseTimeOfDay(json['sessionTime']),
      weather: json['weather'] != null ? WeatherCondition.fromJson(json['weather']) : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class UserAnalysisData {
  final String userId;
  final DateTime analysisStart;
  final DateTime analysisEnd;
  final int totalSessions;
  final double averageCompletionRate;
  final Map<int, int> sessionsByHour;
  final Map<String, int> sessionsByDay;
  final List<int> dailyCompletions;
  final Map<String, double> distractionFactors;
  final int consecutiveDays;
  final double weeklyGrowth;
  final double monthlyGrowth;
  final List<String> topProductiveHours;
  final Map<String, double> taskTypePerformance;
  final double focusStability;
  final List<String> improvementAreas;

  const UserAnalysisData({
    required this.userId,
    required this.analysisStart,
    required this.analysisEnd,
    required this.totalSessions,
    required this.averageCompletionRate,
    required this.sessionsByHour,
    required this.sessionsByDay,
    required this.dailyCompletions,
    required this.distractionFactors,
    required this.consecutiveDays,
    required this.weeklyGrowth,
    required this.monthlyGrowth,
    required this.topProductiveHours,
    required this.taskTypePerformance,
    required this.focusStability,
    required this.improvementAreas,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'analysisStart': analysisStart.toIso8601String(),
      'analysisEnd': analysisEnd.toIso8601String(),
      'totalSessions': totalSessions,
      'averageCompletionRate': averageCompletionRate,
      'sessionsByHour': sessionsByHour,
      'sessionsByDay': sessionsByDay,
      'dailyCompletions': dailyCompletions,
      'distractionFactors': distractionFactors,
      'consecutiveDays': consecutiveDays,
      'weeklyGrowth': weeklyGrowth,
      'monthlyGrowth': monthlyGrowth,
      'topProductiveHours': topProductiveHours,
      'taskTypePerformance': taskTypePerformance,
      'focusStability': focusStability,
      'improvementAreas': improvementAreas,
    };
  }

  factory UserAnalysisData.fromJson(Map<String, dynamic> json) {
    return UserAnalysisData(
      userId: json['userId'],
      analysisStart: DateTime.parse(json['analysisStart']),
      analysisEnd: DateTime.parse(json['analysisEnd']),
      totalSessions: json['totalSessions'],
      averageCompletionRate: json['averageCompletionRate']?.toDouble() ?? 0.0,
      sessionsByHour: Map<int, int>.from(json['sessionsByHour'] ?? {}),
      sessionsByDay: Map<String, int>.from(json['sessionsByDay'] ?? {}),
      dailyCompletions: List<int>.from(json['dailyCompletions'] ?? []),
      distractionFactors: Map<String, double>.from(json['distractionFactors'] ?? {}),
      consecutiveDays: json['consecutiveDays'] ?? 0,
      weeklyGrowth: json['weeklyGrowth']?.toDouble() ?? 0.0,
      monthlyGrowth: json['monthlyGrowth']?.toDouble() ?? 0.0,
      topProductiveHours: List<String>.from(json['topProductiveHours'] ?? []),
      taskTypePerformance: Map<String, double>.from(json['taskTypePerformance'] ?? {}),
      focusStability: json['focusStability']?.toDouble() ?? 0.0,
      improvementAreas: List<String>.from(json['improvementAreas'] ?? []),
    );
  }
}

class WeatherCondition {
  final String condition;
  final double temperature;
  final int humidity;
  final String description;

  const WeatherCondition({
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'temperature': temperature,
      'humidity': humidity,
      'description': description,
    };
  }

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      condition: json['condition'] ?? 'unknown',
      temperature: json['temperature']?.toDouble() ?? 0.0,
      humidity: json['humidity'] ?? 0,
      description: json['description'] ?? '',
    );
  }
} 