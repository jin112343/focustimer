import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../data/models/ai_analysis.dart';
import '../../data/models/focus_pattern.dart';

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  
  AIAnalysis? _currentAnalysis;
  List<AIInsight> _insights = [];
  OptimalTiming? _optimalTiming;
  double _productivityScore = 0.0;
  bool _isAnalyzing = false;
  String? _errorMessage;
  DateTime? _lastAnalysisTime;

  AIAnalysis? get currentAnalysis => _currentAnalysis;
  List<AIInsight> get insights => _insights;
  OptimalTiming? get optimalTiming => _optimalTiming;
  double get productivityScore => _productivityScore;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  DateTime? get lastAnalysisTime => _lastAnalysisTime;

  Future<void> analyzeFocusPatterns(List<FocusPattern> patterns) async {
    if (patterns.isEmpty) return;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final analysis = await _aiService.analyzeFocusPatterns(patterns);
      if (analysis != null) {
        _currentAnalysis = analysis;
        _insights = analysis.insights;
        _optimalTiming = analysis.optimalTiming;
        _lastAnalysisTime = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'AI分析に失敗しました: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> generatePersonalizedInsights(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async {
    if (patterns.isEmpty) return;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final insights = await _aiService.generatePersonalizedInsights(patterns, userData);
      _insights = insights;
      _lastAnalysisTime = DateTime.now();
    } catch (e) {
      _errorMessage = 'AIインサイト生成に失敗しました: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> predictOptimalTiming(List<FocusPattern> patterns) async {
    if (patterns.isEmpty) return;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final timing = await _aiService.predictOptimalTiming(patterns);
      if (timing != null) {
        _optimalTiming = timing;
        _lastAnalysisTime = DateTime.now();
      }
    } catch (e) {
      _errorMessage = '最適タイミング予測に失敗しました: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> calculateProductivityScore(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async {
    if (patterns.isEmpty) return;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final score = await _aiService.calculateProductivityScore(patterns, userData);
      _productivityScore = score;
      _lastAnalysisTime = DateTime.now();
    } catch (e) {
      _errorMessage = '生産性スコア計算に失敗しました: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> performFullAnalysis(List<FocusPattern> patterns) async {
    if (patterns.isEmpty) return;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ユーザーデータを生成（簡略化）
      final userData = _generateUserAnalysisData(patterns);
      
      // 並行して複数の分析を実行
      await Future.wait([
        analyzeFocusPatterns(patterns),
        generatePersonalizedInsights(patterns, userData),
        predictOptimalTiming(patterns),
        calculateProductivityScore(patterns, userData),
      ]);

      _lastAnalysisTime = DateTime.now();
    } catch (e) {
      _errorMessage = 'AI分析に失敗しました: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  UserAnalysisData _generateUserAnalysisData(List<FocusPattern> patterns) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    // 時間別セッション数を計算
    final sessionsByHour = <int, int>{};
    for (final pattern in patterns) {
      final hour = pattern.sessionTime.hour;
      sessionsByHour[hour] = (sessionsByHour[hour] ?? 0) + 1;
    }

    // 平均完了率を計算
    final totalPlanned = patterns.fold<int>(0, (sum, p) => sum + p.plannedDuration);
    final totalActual = patterns.fold<int>(0, (sum, p) => sum + p.actualDuration);
    final averageCompletionRate = totalPlanned > 0 ? totalActual / totalPlanned : 0.0;

    // 最も生産的な時間帯を計算
    final hourProductivity = <int, double>{};
    for (final pattern in patterns) {
      final hour = pattern.sessionTime.hour;
      hourProductivity[hour] = (hourProductivity[hour] ?? 0.0) + pattern.productivityScore;
    }
    
    final topProductiveHours = hourProductivity.entries
        .map((e) => '${e.key.toString().padLeft(2, '0')}:00')
        .take(3)
        .toList();

    return UserAnalysisData(
      userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      analysisStart: weekAgo,
      analysisEnd: now,
      totalSessions: patterns.length,
      averageCompletionRate: averageCompletionRate,
      sessionsByHour: sessionsByHour,
      sessionsByDay: {}, // 簡略化
      dailyCompletions: List.generate(7, (i) => patterns.where((p) => 
        p.timestamp.isAfter(now.subtract(Duration(days: i + 1))) &&
        p.timestamp.isBefore(now.subtract(Duration(days: i)))
      ).length),
      distractionFactors: {}, // 簡略化
      consecutiveDays: _calculateConsecutiveDays(patterns),
      weeklyGrowth: 0.1, // 簡略化
      monthlyGrowth: 0.05, // 簡略化
      topProductiveHours: topProductiveHours,
      taskTypePerformance: {}, // 簡略化
      focusStability: 0.8, // 簡略化
      improvementAreas: ['集中時間の延長', '中断の削減'], // 簡略化
    );
  }

  int _calculateConsecutiveDays(List<FocusPattern> patterns) {
    if (patterns.isEmpty) return 0;

    final sortedPatterns = patterns.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    int consecutiveDays = 0;
    DateTime? lastDate;

    for (final pattern in sortedPatterns) {
      final patternDate = DateTime(
        pattern.timestamp.year,
        pattern.timestamp.month,
        pattern.timestamp.day,
      );

      if (lastDate == null) {
        lastDate = patternDate;
        consecutiveDays = 1;
      } else if (patternDate.isAtSameMomentAs(lastDate)) {
        // 同じ日なのでスキップ
        continue;
      } else if (patternDate.difference(lastDate).inDays == 1) {
        // 連続日
        consecutiveDays++;
        lastDate = patternDate;
      } else {
        // 連続が途切れた
        break;
      }
    }

    return consecutiveDays;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _currentAnalysis = null;
    _insights = [];
    _optimalTiming = null;
    _productivityScore = 0.0;
    _errorMessage = null;
    _lastAnalysisTime = null;
    notifyListeners();
  }
} 