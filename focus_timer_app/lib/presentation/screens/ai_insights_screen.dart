import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/ai_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/ai/ai_insight_card.dart';
import '../widgets/ai/productivity_score.dart';
import '../widgets/ai/focus_chart.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/common/responsive_card.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/ai_analysis.dart';
import '../../data/models/focus_pattern.dart';
import 'dart:ui';
import '../../l10n/app_localizations.dart';

class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  bool _analysisRequested = false;
  String _selectedPeriod = '日'; // '日', '週', '月'

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_analysisRequested) {
      final aiProvider = context.read<AIProvider>();
      final timerProvider = context.read<TimerProvider>();
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
      aiProvider.performFullAnalysis(patterns);
      _analysisRequested = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.aiInsights,
          style: GoogleFonts.notoSans(
            fontSize: ResponsiveUtils.getTitleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: ResponsiveUtils.getResponsiveIconSize(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getResponsiveIconSize(context),
            ),
            onPressed: () => _refreshAnalysis(context),
          ),
        ],
      ),
      body: Consumer2<AIProvider, TimerProvider>(
        builder: (context, aiProvider, timerProvider, child) {
          final sessionHistory = timerProvider.state.sessionHistory;
          // 実績データのみで日・週・月ごとに集計
          final period = _selectedPeriod;
          final avgMap = getAverageCompletionByPeriod(sessionHistory, period);
          // ラベル生成
          List<String> labels;
          if (period == '週') {
            labels = avgMap.keys.map((k) {
              // k: yyyy-Wxx から週の月曜の日付を算出
              final parts = k.split('-W');
              final year = int.parse(parts[0]);
              final week = int.parse(parts[1]);
              final monday = DateTime.utc(year, 1, 1 + (week - 1) * 7);
              return formatWeekLabel(monday);
            }).toList();
          } else if (period == '月') {
            labels = avgMap.keys.map((k) {
              // k: yyyy-MM から月初の日付
              final parts = k.split('-');
              final year = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final firstDay = DateTime(year, month, 1);
              return formatMonthLabel(firstDay);
            }).toList();
          } else {
            labels = avgMap.keys.toList()..sort();
          }
          final data = labels.asMap().entries.map((e) => avgMap[avgMap.keys.toList()[e.key]] ?? 0.0).toList();
          final isValidPattern = labels.isNotEmpty && data.any((v) => v > 0 && v < 1);
          final insights = aiProvider.insights;
          final isAnalyzing = aiProvider.isAnalyzing;
          final errorMessage = aiProvider.errorMessage;
          final lastAnalysisTime = aiProvider.lastAnalysisTime;
          final patterns = aiProvider.currentAnalysis?.patterns ?? {};

          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, aiProvider, timerProvider, avgMap, labels, data, isValidPattern, insights, isAnalyzing, errorMessage, lastAnalysisTime, patterns),
            tablet: _buildTabletLayout(context, aiProvider, timerProvider, avgMap, labels, data, isValidPattern, insights, isAnalyzing, errorMessage, lastAnalysisTime, patterns),
            ipad: _buildIPadLayout(context, aiProvider, timerProvider, avgMap, labels, data, isValidPattern, insights, isAnalyzing, errorMessage, lastAnalysisTime, patterns),
            desktop: _buildDesktopLayout(context, aiProvider, timerProvider, avgMap, labels, data, isValidPattern, insights, isAnalyzing, errorMessage, lastAnalysisTime, patterns),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AIProvider aiProvider, TimerProvider timerProvider, Map<String, double> avgMap, List<String> labels, List<double> data, bool isValidPattern, List<AIInsight> insights, bool isAnalyzing, String? errorMessage, DateTime? lastAnalysisTime, Map<String, dynamic> patterns) {
    return RefreshIndicator(
      onRefresh: () => _refreshAnalysis(context),
      child: ListView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        children: [
          // ヘッダー情報
          _buildHeader(aiProvider, lastAnalysisTime),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // 期間切り替えタブ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPeriodTab('日'),
              _buildPeriodTab('週'),
              _buildPeriodTab('月'),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
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
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // 集中度グラフ（本物の値のみ）
          if (isValidPattern)
            FocusChart(
              data: data,
              labels: labels,
              title: AppLocalizations.of(context)!.concentrationTrend(_selectedPeriod),
            ),
          if (!isValidPattern)
            ResponsiveCard(
              child: Text(
                AppLocalizations.of(context)!.noConcentrationData(_selectedPeriod),
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getBodyFontSize(context),
                  color: AppColors.textColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // AIインサイトカード
          if (insights.isNotEmpty) ...[
            _buildSectionHeader(AppLocalizations.of(context)!.personalizedAdvice),
            ...insights.map((insight) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
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
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // 最適タイミング予測
          if (aiProvider.optimalTiming != null)
            _buildOptimalTimingCard(context, aiProvider.optimalTiming!),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // 習慣形成の進捗
          _buildHabitFormationCard(timerProvider),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // 手動更新ボタン
          _buildRefreshButton(context, aiProvider),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AIProvider aiProvider, TimerProvider timerProvider, Map<String, double> avgMap, List<String> labels, List<double> data, bool isValidPattern, List<AIInsight> insights, bool isAnalyzing, String? errorMessage, DateTime? lastAnalysisTime, Map<String, dynamic> patterns) {
    return RefreshIndicator(
      onRefresh: () => _refreshAnalysis(context),
      child: Row(
        children: [
          // 左側: ヘッダー、スコア、グラフ
          Expanded(
            flex: 1,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                _buildHeader(aiProvider, lastAnalysisTime),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 期間切り替えタブ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPeriodTab('日'),
                    _buildPeriodTab('週'),
                    _buildPeriodTab('月'),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
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
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 集中度グラフ
                if (isValidPattern)
                  FocusChart(
                    data: data,
                    labels: labels,
                    title: AppLocalizations.of(context)!.concentrationTrend(_selectedPeriod),
                  ),
                if (!isValidPattern)
                  ResponsiveCard(
                    child: Text(
                      AppLocalizations.of(context)!.noConcentrationData(_selectedPeriod),
                      style: GoogleFonts.notoSans(
                        fontSize: ResponsiveUtils.getBodyFontSize(context),
                        color: AppColors.textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // 右側: AIインサイト、タイミング、習慣
          Expanded(
            flex: 1,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                // AIインサイトカード
                if (insights.isNotEmpty) ...[
                  _buildSectionHeader(AppLocalizations.of(context)!.personalizedAdvice),
                  ...insights.map((insight) => Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
                    child: AIInsightCard(
                      title: insight.title,
                      content: insight.description,
                      confidenceScore: insight.confidenceScore,
                      icon: _getInsightIcon(insight.type),
                      iconColor: _getInsightColor(insight.type),
                      onTap: () => _showInsightDetails(context, insight),
                    ),
                  )),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                ],
                
                // 最適タイミング予測
                if (aiProvider.optimalTiming != null)
                  _buildOptimalTimingCard(context, aiProvider.optimalTiming!),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 習慣形成の進捗
                _buildHabitFormationCard(timerProvider),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 手動更新ボタン
                _buildRefreshButton(context, aiProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIPadLayout(BuildContext context, AIProvider aiProvider, TimerProvider timerProvider, Map<String, double> avgMap, List<String> labels, List<double> data, bool isValidPattern, List<AIInsight> insights, bool isAnalyzing, String? errorMessage, DateTime? lastAnalysisTime, Map<String, dynamic> patterns) {
    return RefreshIndicator(
      onRefresh: () => _refreshAnalysis(context),
      child: Row(
        children: [
          // 左側: ヘッダーとスコア (30%)
          Expanded(
            flex: 3,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                _buildHeader(aiProvider, lastAnalysisTime),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 期間切り替えタブ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPeriodTab('日'),
                    _buildPeriodTab('週'),
                    _buildPeriodTab('月'),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
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
              ],
            ),
          ),
          
          // 中央: グラフとAIインサイト (40%)
          Expanded(
            flex: 4,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                // 集中度グラフ
                if (isValidPattern)
                  FocusChart(
                    data: data,
                    labels: labels,
                    title: AppLocalizations.of(context)!.concentrationTrend(_selectedPeriod),
                  ),
                if (!isValidPattern)
                  ResponsiveCard(
                    child: Text(
                      AppLocalizations.of(context)!.noConcentrationData(_selectedPeriod),
                      style: GoogleFonts.notoSans(
                        fontSize: ResponsiveUtils.getBodyFontSize(context),
                        color: AppColors.textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // AIインサイトカード
                if (insights.isNotEmpty) ...[
                  _buildSectionHeader(AppLocalizations.of(context)!.personalizedAdvice),
                  ...insights.map((insight) => Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
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
              ],
            ),
          ),
          
          // 右側: タイミング、習慣、更新ボタン (30%)
          Expanded(
            flex: 3,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                // 最適タイミング予測
                if (aiProvider.optimalTiming != null)
                  _buildOptimalTimingCard(context, aiProvider.optimalTiming!),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 習慣形成の進捗
                _buildHabitFormationCard(timerProvider),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 手動更新ボタン
                _buildRefreshButton(context, aiProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AIProvider aiProvider, TimerProvider timerProvider, Map<String, double> avgMap, List<String> labels, List<double> data, bool isValidPattern, List<AIInsight> insights, bool isAnalyzing, String? errorMessage, DateTime? lastAnalysisTime, Map<String, dynamic> patterns) {
    return RefreshIndicator(
      onRefresh: () => _refreshAnalysis(context),
      child: Row(
        children: [
          // 左側: ヘッダーとスコア
          Expanded(
            flex: 1,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                _buildHeader(aiProvider, lastAnalysisTime),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 期間切り替えタブ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPeriodTab('日'),
                    _buildPeriodTab('週'),
                    _buildPeriodTab('月'),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
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
              ],
            ),
          ),
          
          // 中央: グラフ
          Expanded(
            flex: 1,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                // 集中度グラフ
                if (isValidPattern)
                  FocusChart(
                    data: data,
                    labels: labels,
                    title: AppLocalizations.of(context)!.concentrationTrend(_selectedPeriod),
                  ),
                if (!isValidPattern)
                  ResponsiveCard(
                    child: Text(
                      AppLocalizations.of(context)!.noConcentrationData(_selectedPeriod),
                      style: GoogleFonts.notoSans(
                        fontSize: ResponsiveUtils.getBodyFontSize(context),
                        color: AppColors.textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // 右側: AIインサイト、タイミング、習慣
          Expanded(
            flex: 1,
            child: ListView(
              padding: ResponsiveUtils.getResponsivePadding(context),
              children: [
                // AIインサイトカード
                if (insights.isNotEmpty) ...[
                  _buildSectionHeader(AppLocalizations.of(context)!.personalizedAdvice),
                  ...insights.map((insight) => Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
                    child: AIInsightCard(
                      title: insight.title,
                      content: insight.description,
                      confidenceScore: insight.confidenceScore,
                      icon: _getInsightIcon(insight.type),
                      iconColor: _getInsightColor(insight.type),
                      onTap: () => _showInsightDetails(context, insight),
                    ),
                  )),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                ],
                
                // 最適タイミング予測
                if (aiProvider.optimalTiming != null)
                  _buildOptimalTimingCard(context, aiProvider.optimalTiming!),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 習慣形成の進捗
                _buildHabitFormationCard(timerProvider),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                
                // 手動更新ボタン
                _buildRefreshButton(context, aiProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AIProvider aiProvider, DateTime? lastAnalysisTime) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveIconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.aiAnalysisResult,
                  style: GoogleFonts.notoSans(
                    fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            lastAnalysisTime != null
                ? AppLocalizations.of(context)!.lastUpdated(formatTimeAgo(lastAnalysisTime))
                : AppLocalizations.of(context)!.noAnalysisData,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String errorMessage, AIProvider aiProvider) {
    return ResponsiveCard(
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.errorColor,
            size: ResponsiveUtils.getResponsiveIconSize(context),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
          Expanded(
            child: Text(
              errorMessage,
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
                color: AppColors.errorColor,
              ),
            ),
          ),
          TextButton(
            onPressed: aiProvider.clearError,
            child: Text(
              AppLocalizations.of(context)!.close,
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
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
    return ResponsiveCard(
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveUtils.getResponsiveIconSize(context),
            height: ResponsiveUtils.getResponsiveIconSize(context),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.aiPrimaryColor),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            AppLocalizations.of(context)!.aiAnalyzing,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
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
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context)),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: ResponsiveUtils.getSubtitleFontSize(context),
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _buildOptimalTimingCard(BuildContext context, OptimalTiming timing) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.aiPrimaryColor,
                size: ResponsiveUtils.getResponsiveIconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                AppLocalizations.of(context)!.optimalTimingPrediction,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(context), 
                  vertical: ResponsiveUtils.getResponsiveSpacing(context) / 2
                ),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
                ),
                child: Text(
                  '${(timing.confidenceLevel * 100).toInt()}%',
                  style: GoogleFonts.notoSans(
                    fontSize: ResponsiveUtils.getCaptionFontSize(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.successColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            AppLocalizations.of(context)!.recommendedSchedule,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            '• ${timing.bestWorkTime.format(context)}-${_addTimeOfDay(timing.bestWorkTime, const Duration(hours: 2)).format(context)} 集中作業',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '• ${timing.bestBreakTime.format(context)}-${_addTimeOfDay(timing.bestBreakTime, const Duration(minutes: 15)).format(context)} 短い休憩',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            AppLocalizations.of(context)!.predictedSessions(timing.recommendedSessions),
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
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

    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppColors.aiPrimaryColor,
                size: ResponsiveUtils.getResponsiveIconSize(context),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                AppLocalizations.of(context)!.habitFormationProgress,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.consecutiveUsage(consecutiveDays),
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getBodyFontSize(context),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.local_fire_department,
                color: AppColors.workColor,
                size: ResponsiveUtils.getResponsiveIconSize(context),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            AppLocalizations.of(context)!.weeklyGoalAchievement((weeklyGoal * 100).toInt()),
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            AppLocalizations.of(context)!.nextMilestone(nextMilestone, nextMilestone - consecutiveDays),
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
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
        icon: Icon(
          Icons.refresh,
          size: ResponsiveUtils.getResponsiveIconSize(context),
        ),
        label: Text(
          AppLocalizations.of(context)!.aiRefresh,
          style: GoogleFonts.notoSans(
            fontSize: ResponsiveUtils.getBodyFontSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aiPrimaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context), 
            vertical: ResponsiveUtils.getResponsiveSpacing(context)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
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

  String formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return AppLocalizations.of(context)!.justNow;
    } else if (difference.inMinutes < 60) {
      return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context)!.hoursAgo(difference.inHours);
    } else {
      return AppLocalizations.of(context)!.daysAgo(difference.inDays);
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
        title: Text(
          insight.title, 
          style: GoogleFonts.notoSans(
            fontSize: ResponsiveUtils.getTitleFontSize(context),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              insight.description,
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
              ),
            ),
            if (insight.actionItems.isNotEmpty) ...[
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                AppLocalizations.of(context)!.actionableActions,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              ...insight.actionItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context) / 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle, 
                      size: ResponsiveUtils.getResponsiveIconSize(context), 
                      color: AppColors.successColor
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.notoSans(
                          fontSize: ResponsiveUtils.getBodyFontSize(context),
                        ),
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
            child: Text(
              AppLocalizations.of(context)!.close, 
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
              ),
            ),
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

  Widget _buildPeriodTab(String label) {
    final isSelected = _selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = label;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context), 
          vertical: ResponsiveUtils.getResponsiveSpacing(context)
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.aiPrimaryColor : AppColors.cardColor,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
          border: Border.all(
            color: isSelected ? AppColors.aiPrimaryColor : AppColors.cardColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: ResponsiveUtils.getBodyFontSize(context),
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textColor,
          ),
        ),
      ),
    );
  }
} 