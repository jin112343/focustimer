import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/ai_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/ai/ai_insight_card.dart';
import '../widgets/ai/productivity_score.dart';
import '../../core/constants/colors.dart';
import '../../data/models/ai_analysis.dart';
import '../../data/models/focus_pattern.dart';

class AIInsightsScreen extends StatelessWidget {
  const AIInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          '🤖 AI インサイト',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshAnalysis(context),
          ),
        ],
      ),
      body: Consumer2<AIProvider, TimerProvider>(
        builder: (context, aiProvider, timerProvider, child) {
          final insights = aiProvider.insights;
          final isAnalyzing = aiProvider.isAnalyzing;
          final errorMessage = aiProvider.errorMessage;
          final lastAnalysisTime = aiProvider.lastAnalysisTime;

          return RefreshIndicator(
            onRefresh: () => _refreshAnalysis(context),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ヘッダー情報
                _buildHeader(aiProvider, lastAnalysisTime),
                
                const SizedBox(height: 24),
                
                // エラーメッセージ
                if (errorMessage != null)
                  _buildErrorMessage(errorMessage, aiProvider),
                
                // 分析中表示
                if (isAnalyzing)
                  _buildAnalyzingIndicator(),
                
                // 生産性スコア
                if (aiProvider.productivityScore > 0)
                  ProductivityScore(
                    score: aiProvider.productivityScore,
                    trend: aiProvider.currentAnalysis?.productivityTrend ?? 0.0,
                  ),
                
                const SizedBox(height: 24),
                
                // AIインサイトカード
                if (insights.isNotEmpty) ...[
                  _buildSectionHeader('💡 個人化されたアドバイス'),
                  ...insights.map((insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AIInsightCard(
                      title: insight.title,
                      content: insight.description,
                      confidenceScore: insight.confidenceScore,
                      icon: _getInsightIcon(insight.type),
                      iconColor: _getInsightColor(insight.type),
                      onTap: () => _showInsightDetails(context, insight),
                    ),
                  )),
                ],
                
                const SizedBox(height: 24),
                
                // 最適タイミング予測
                if (aiProvider.optimalTiming != null)
                  _buildOptimalTimingCard(context, aiProvider.optimalTiming!),
                
                const SizedBox(height: 24),
                
                // 習慣形成の進捗
                _buildHabitFormationCard(timerProvider),
                
                const SizedBox(height: 24),
                
                // 手動更新ボタン
                _buildRefreshButton(context, aiProvider),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(AIProvider aiProvider, DateTime? lastAnalysisTime) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.aiPrimaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.aiPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI分析結果',
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            lastAnalysisTime != null
                ? '最終更新: ${_formatTimeAgo(lastAnalysisTime)}'
                : '分析データがありません',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String errorMessage, AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.errorColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppColors.errorColor,
              ),
            ),
          ),
          TextButton(
            onPressed: aiProvider.clearError,
            child: Text(
              '閉じる',
              style: GoogleFonts.notoSans(
                color: AppColors.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.aiPrimaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.aiPrimaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.aiPrimaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AI分析中...',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.aiPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _buildOptimalTimingCard(BuildContext context, OptimalTiming timing) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: AppColors.aiPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '最適タイミング予測',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(timing.confidenceLevel * 100).toInt()}%',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.successColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '推奨スケジュール:',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• ${timing.bestWorkTime.format(context)}-${_addTimeOfDay(timing.bestWorkTime, const Duration(hours: 2)).format(context)} 集中作業',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '• ${timing.bestBreakTime.format(context)}-${_addTimeOfDay(timing.bestBreakTime, const Duration(minutes: 15)).format(context)} 短い休憩',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '予想完了セッション: ${timing.recommendedSessions}',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.aiPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitFormationCard(TimerProvider timerProvider) {
    final consecutiveDays = 12; // 仮の値
    final weeklyGoal = 0.85; // 仮の値
    final nextMilestone = 14; // 仮の値

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: AppColors.aiPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '習慣形成の進捗',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '連続使用: $consecutiveDays日 ',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              const Icon(
                Icons.local_fire_department,
                color: AppColors.workColor,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '週間目標達成率: ${(weeklyGoal * 100).toInt()}%',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '次のマイルストーン: 連続${nextMilestone}日使用まで あと${nextMilestone - consecutiveDays}日',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.aiPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context, AIProvider aiProvider) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: aiProvider.isAnalyzing ? null : () => _refreshAnalysis(context),
        icon: const Icon(Icons.refresh),
        label: Text(
          'AI分析を更新',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aiPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  TimeOfDay _addTimeOfDay(TimeOfDay time, Duration duration) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDateTime = dateTime.add(duration);
    return TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '今';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else {
      return '${difference.inDays}日前';
    }
  }

  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.productivityTrend:
        return Icons.trending_up;
      case InsightType.optimalTiming:
        return Icons.schedule;
      case InsightType.habitFormation:
        return Icons.psychology;
      case InsightType.distractionPattern:
        return Icons.notifications_off;
      case InsightType.improvementSuggestion:
        return Icons.lightbulb_outline;
      case InsightType.healthAlert:
        return Icons.health_and_safety;
      case InsightType.motivationBoost:
        return Icons.emoji_events;
    }
  }

  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.productivityTrend:
        return AppColors.successColor;
      case InsightType.optimalTiming:
        return AppColors.aiPrimaryColor;
      case InsightType.habitFormation:
        return AppColors.workColor;
      case InsightType.distractionPattern:
        return AppColors.warningColor;
      case InsightType.improvementSuggestion:
        return AppColors.infoColor;
      case InsightType.healthAlert:
        return AppColors.errorColor;
      case InsightType.motivationBoost:
        return AppColors.aiAccentColor;
    }
  }

  void _showInsightDetails(BuildContext context, AIInsight insight) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(insight.title, style: GoogleFonts.notoSans()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              insight.description,
              style: GoogleFonts.notoSans(fontSize: 14),
            ),
            if (insight.actionItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '実行可能なアクション:',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...insight.actionItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: AppColors.successColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.notoSans(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('閉じる', style: GoogleFonts.notoSans()),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAnalysis(BuildContext context) async {
    final aiProvider = context.read<AIProvider>();
    final timerProvider = context.read<TimerProvider>();
    
    // セッション履歴からFocusPatternを生成（簡略化）
    final patterns = timerProvider.state.sessionHistory.map((session) {
      return FocusPattern(
        id: session.id,
        timestamp: session.startTime,
        plannedDuration: session.plannedDuration,
        actualDuration: session.actualDuration,
        interruptions: session.interruptions,
        taskType: session.isWorkSession ? 'work' : 'break',
        taskCategory: 'general',
        productivityScore: session.completionRate,
        sessionTime: TimeOfDay.fromDateTime(session.startTime),
      );
    }).toList();

    await aiProvider.performFullAnalysis(patterns);
  }
} 