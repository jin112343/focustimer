import '../data/models/ai_analysis.dart';
import '../data/models/focus_pattern.dart';

/// Preserves the existing unavailable-AI behavior without sending user data.
///
/// A provider credential embedded in a distributed app is extractable. Remote
/// analysis must stay off until a server endpoint with authentication, quotas,
/// timeouts and server-held credentials replaces the direct client integration.
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Future<void> initialize() async {}

  Future<AIAnalysis?> analyzeFocusPatterns(List<FocusPattern> patterns) async =>
      null;

  Future<List<AIInsight>> generatePersonalizedInsights(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async => const [];

  Future<OptimalTiming?> predictOptimalTiming(
    List<FocusPattern> patterns,
  ) async => null;

  Future<double> calculateProductivityScore(
    List<FocusPattern> patterns,
    UserAnalysisData userData,
  ) async => 75.0; // Existing fallback value; not a generated assessment.
}
