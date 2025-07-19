import 'package:flutter/material.dart';

class AIAnalysis {
  final DateTime analysisDate;
  final double focusScore;
  final double productivityTrend;
  final List<AIInsight> insights;
  final List<String> suggestions;
  final Map<String, double> patterns;
  final OptimalTiming optimalTiming;
  final PredictionData predictions;

  const AIAnalysis({
    required this.analysisDate,
    required this.focusScore,
    required this.productivityTrend,
    required this.insights,
    required this.suggestions,
    required this.patterns,
    required this.optimalTiming,
    required this.predictions,
  });

  Map<String, dynamic> toJson() {
    return {
      'analysisDate': analysisDate.toIso8601String(),
      'focusScore': focusScore,
      'productivityTrend': productivityTrend,
      'insights': insights.map((i) => i.toJson()).toList(),
      'suggestions': suggestions,
      'patterns': patterns,
      'optimalTiming': optimalTiming.toJson(),
      'predictions': predictions.toJson(),
    };
  }

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      analysisDate: DateTime.parse(json['analysisDate']),
      focusScore: json['focusScore']?.toDouble() ?? 0.0,
      productivityTrend: json['productivityTrend']?.toDouble() ?? 0.0,
      insights: (json['insights'] as List?)
          ?.map((i) => AIInsight.fromJson(i))
          .toList() ?? [],
      suggestions: List<String>.from(json['suggestions'] ?? []),
      patterns: Map<String, double>.from(json['patterns'] ?? {}),
      optimalTiming: OptimalTiming.fromJson(json['optimalTiming'] ?? {}),
      predictions: PredictionData.fromJson(json['predictions'] ?? {}),
    );
  }
}

class AIInsight {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final double confidenceScore;
  final DateTime generatedAt;
  final List<String> actionItems;
  final String geminiReasoning;

  const AIInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.confidenceScore,
    required this.generatedAt,
    required this.actionItems,
    required this.geminiReasoning,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'confidenceScore': confidenceScore,
      'generatedAt': generatedAt.toIso8601String(),
      'actionItems': actionItems,
      'geminiReasoning': geminiReasoning,
    };
  }

  factory AIInsight.fromJson(Map<String, dynamic> json) {
    return AIInsight(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: InsightType.values[json['type'] ?? 0],
      confidenceScore: json['confidenceScore']?.toDouble() ?? 0.0,
      generatedAt: DateTime.parse(json['generatedAt']),
      actionItems: List<String>.from(json['actionItems'] ?? []),
      geminiReasoning: json['geminiReasoning'] ?? '',
    );
  }
}

enum InsightType {
  productivityTrend,
  optimalTiming,
  habitFormation,
  distractionPattern,
  improvementSuggestion,
  healthAlert,
  motivationBoost,
}

class OptimalTiming {
  final TimeOfDay bestWorkTime;
  final TimeOfDay bestBreakTime;
  final int recommendedSessions;
  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final double confidenceLevel;
  final String aiReasoning;

  const OptimalTiming({
    required this.bestWorkTime,
    required this.bestBreakTime,
    required this.recommendedSessions,
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.confidenceLevel,
    required this.aiReasoning,
  });

  Map<String, dynamic> toJson() {
    return {
      'bestWorkTime': '${bestWorkTime.hour}:${bestWorkTime.minute}',
      'bestBreakTime': '${bestBreakTime.hour}:${bestBreakTime.minute}',
      'recommendedSessions': recommendedSessions,
      'workDuration': workDuration.inMinutes,
      'shortBreakDuration': shortBreakDuration.inMinutes,
      'longBreakDuration': longBreakDuration.inMinutes,
      'confidenceLevel': confidenceLevel,
      'aiReasoning': aiReasoning,
    };
  }

  factory OptimalTiming.fromJson(Map<String, dynamic> json) {
    final workTimeStr = json['bestWorkTime'] ?? '09:00';
    final breakTimeStr = json['bestBreakTime'] ?? '11:00';
    
    return OptimalTiming(
      bestWorkTime: _parseTimeOfDay(workTimeStr),
      bestBreakTime: _parseTimeOfDay(breakTimeStr),
      recommendedSessions: json['recommendedSessions'] ?? 6,
      workDuration: Duration(minutes: json['workDuration'] ?? 25),
      shortBreakDuration: Duration(minutes: json['shortBreakDuration'] ?? 5),
      longBreakDuration: Duration(minutes: json['longBreakDuration'] ?? 15),
      confidenceLevel: json['confidenceLevel']?.toDouble() ?? 0.8,
      aiReasoning: json['aiReasoning'] ?? '',
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

class PredictionData {
  final double nextWeekProductivity;
  final double nextMonthProductivity;
  final List<String> predictedChallenges;
  final List<String> predictedOpportunities;
  final double confidenceLevel;

  const PredictionData({
    required this.nextWeekProductivity,
    required this.nextMonthProductivity,
    required this.predictedChallenges,
    required this.predictedOpportunities,
    required this.confidenceLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'nextWeekProductivity': nextWeekProductivity,
      'nextMonthProductivity': nextMonthProductivity,
      'predictedChallenges': predictedChallenges,
      'predictedOpportunities': predictedOpportunities,
      'confidenceLevel': confidenceLevel,
    };
  }

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
      nextWeekProductivity: json['nextWeekProductivity']?.toDouble() ?? 0.0,
      nextMonthProductivity: json['nextMonthProductivity']?.toDouble() ?? 0.0,
      predictedChallenges: List<String>.from(json['predictedChallenges'] ?? []),
      predictedOpportunities: List<String>.from(json['predictedOpportunities'] ?? []),
      confidenceLevel: json['confidenceLevel']?.toDouble() ?? 0.7,
    );
  }
} 