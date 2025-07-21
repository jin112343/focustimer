import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../data/models/ai_analysis.dart';
import '../data/models/focus_pattern.dart';
import '../core/constants/ai_prompts.dart';
import '../core/constants/api_keys.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  GenerativeModel? _model;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final apiKey = APIKeys.geminiApiKey;
      if (apiKey.isEmpty) {
        // APIキーが設定されていない場合は初期化をスキップ
        print('Gemini API key not found, AI features will be disabled');
        return;
      }

      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      _isInitialized = true;
    } catch (e) {
      print('AIService initialization failed: $e');
      // エラーが発生してもアプリを停止させない
    }
  }

  Future<AIAnalysis?> analyzeFocusPatterns(List<FocusPattern> patterns) async {
    try {
      await initialize();
      if (_model == null) {
        print('AI model not initialized, returning null');
        return null;
      }

      final prompt = _buildAnalysisPrompt(patterns);
      final response = await _model!.generateContent([Content.text(prompt)]);
      
      if (response.text == null) return null;

      return _parseAnalysisResponse(response.text!);
    } catch (e) {
      print('AI analysis failed: $e');
      return null;
    }
  }

  Future<List<AIInsight>> generatePersonalizedInsights(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async {
    try {
      await initialize();
      if (_model == null) {
        print('AI model not initialized, returning empty list');
        return [];
      }

      final prompt = _buildInsightsPrompt(patterns, userData);
      final response = await _model!.generateContent([Content.text(prompt)]);
      
      if (response.text == null) return [];

      return _parseInsightsResponse(response.text!);
    } catch (e) {
      print('AI insights generation failed: $e');
      return [];
    }
  }

  Future<OptimalTiming?> predictOptimalTiming(List<FocusPattern> patterns) async {
    try {
      await initialize();
      if (_model == null) {
        print('AI model not initialized, returning null');
        return null;
      }

      final prompt = _buildTimingPrompt(patterns);
      final response = await _model!.generateContent([Content.text(prompt)]);
      
      if (response.text == null) return null;

      return _parseTimingResponse(response.text!);
    } catch (e) {
      print('AI timing prediction failed: $e');
      return null;
    }
  }

  Future<double> calculateProductivityScore(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async {
    try {
      await initialize();
      if (_model == null) {
        print('AI model not initialized, returning default score');
        return 75.0; // デフォルトスコア
      }

      final prompt = _buildScorePrompt(patterns, userData);
      final response = await _model!.generateContent([Content.text(prompt)]);
      
      if (response.text == null) return 75.0;

      return _parseScoreResponse(response.text!);
    } catch (e) {
      print('AI score calculation failed: $e');
      return 75.0; // デフォルトスコア
    }
  }

  String _buildAnalysisPrompt(List<FocusPattern> patterns) {
    final data = patterns.map((p) => {
      'timestamp': p.timestamp.toIso8601String(),
      'plannedDuration': p.plannedDuration,
      'actualDuration': p.actualDuration,
      'interruptions': p.interruptions,
      'taskType': p.taskType,
      'sessionTime': p.sessionTime.toString(),
      'productivityScore': p.productivityScore,
    }).toList();

    return '''
${AIPrompts.focusPatternAnalysis}

ユーザーデータ:
${jsonEncode(data)}

分析結果をJSON形式で返してください。
''';
  }

  String _buildInsightsPrompt(List<FocusPattern> patterns, UserAnalysisData userData) {
    return '''
${AIPrompts.personalizedAdvice}

ユーザーデータ:
- 総セッション数: ${userData.totalSessions}
- 平均完了率: ${userData.averageCompletionRate}
- 連続使用日数: ${userData.consecutiveDays}
- 週間成長率: ${userData.weeklyGrowth}

パターンデータ:
${jsonEncode(patterns.map((p) => p.toJson()).toList())}

個人化されたインサイトをJSON形式で返してください。
''';
  }

  String _buildTimingPrompt(List<FocusPattern> patterns) {
    final timingData = patterns.map((p) => {
      'hour': p.sessionTime.hour,
      'completionRate': p.completionRate,
      'productivityScore': p.productivityScore,
    }).toList();

    return '''
${AIPrompts.optimalTimingPrediction}

使用データ:
${jsonEncode(timingData)}

最適タイミングをJSON形式で返してください。
''';
  }

  String _buildScorePrompt(List<FocusPattern> patterns, UserAnalysisData userData) {
    return '''
${AIPrompts.productivityScoreCalculation}

評価データ:
- 完了率: ${userData.averageCompletionRate}
- 継続性: ${userData.consecutiveDays / 30.0}
- 成長率: ${userData.weeklyGrowth}

生産性スコアを0-100の数値で返してください。
''';
  }

  AIAnalysis? _parseAnalysisResponse(String response) {
    try {
      final json = jsonDecode(response);
      return AIAnalysis.fromJson(json);
    } catch (e) {
      print('Failed to parse analysis response: $e');
      return null;
    }
  }

  List<AIInsight> _parseInsightsResponse(String response) {
    try {
      final json = jsonDecode(response);
      final insights = json['insights'] as List;
      return insights.map((i) => AIInsight.fromJson(i)).toList();
    } catch (e) {
      print('Failed to parse insights response: $e');
      return [];
    }
  }

  OptimalTiming? _parseTimingResponse(String response) {
    try {
      final json = jsonDecode(response);
      return OptimalTiming.fromJson(json);
    } catch (e) {
      print('Failed to parse timing response: $e');
      return null;
    }
  }

  double _parseScoreResponse(String response) {
    try {
      final score = double.tryParse(response.replaceAll(RegExp(r'[^0-9.]'), ''));
      return score ?? 75.0;
    } catch (e) {
      print('Failed to parse score response: $e');
      return 75.0;
    }
  }
} 