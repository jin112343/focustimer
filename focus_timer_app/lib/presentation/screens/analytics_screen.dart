import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/timer_provider.dart';
import '../providers/ai_provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../widgets/common/responsive_layout.dart';
import '../../l10n/app_localizations.dart';

enum AnalyticsPeriod { day, week, month }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _selectedPeriod = AnalyticsPeriod.week;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.analytics,
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
      ),
      body: Consumer2<TimerProvider, AIProvider>(
        builder: (context, timerProvider, aiProvider, child) {
          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, timerProvider, aiProvider),
            tablet: _buildTabletLayout(context, timerProvider, aiProvider),
            ipad: _buildIPadLayout(context, timerProvider, aiProvider),
            desktop: _buildDesktopLayout(context, timerProvider, aiProvider),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, TimerProvider timerProvider, AIProvider aiProvider) {
    return Column(
      children: [
        // 期間選択タブ
        _buildPeriodTabs(),
        
        Expanded(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                children: [
                  // 今週のパフォーマンス
                  _buildPerformanceHeader(),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 集中度グラフ
                  _buildFocusChart(),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 重要指標
                  _buildKeyMetrics(),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 最も生産的な時間帯
                  _buildProductiveHours(),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // セッション分布（ヒートマップ）
                  _buildSessionHeatmap(),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // AI詳細分析ボタン
                  _buildAIAnalysisButton(context, aiProvider, timerProvider),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, TimerProvider timerProvider, AIProvider aiProvider) {
    return Column(
      children: [
        // 期間選択タブ
        _buildPeriodTabs(),
        
        Expanded(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: ResponsiveGrid(
                children: [
                  // 左側: パフォーマンスヘッダーとグラフ
                  _buildPerformanceHeader(),
                  _buildFocusChart(),
                  _buildKeyMetrics(),
                  
                  // 右側: 生産的時間とヒートマップ
                  _buildProductiveHours(),
                  _buildSessionHeatmap(),
                  _buildAIAnalysisButton(context, aiProvider, timerProvider),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIPadLayout(BuildContext context, TimerProvider timerProvider, AIProvider aiProvider) {
    return Column(
      children: [
        // 期間選択タブ
        _buildPeriodTabs(),
        
        Expanded(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Row(
                children: [
                  // 左側: パフォーマンスとグラフ (40%)
                  Expanded(
                    flex: 4,
                    child: ResponsiveColumn(
                      children: [
                        _buildPerformanceHeader(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildFocusChart(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildKeyMetrics(),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 中央: 生産的時間とヒートマップ (35%)
                  Expanded(
                    flex: 3,
                    child: ResponsiveColumn(
                      children: [
                        _buildProductiveHours(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildSessionHeatmap(),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 右側: AI分析ボタン (25%)
                  Expanded(
                    flex: 2,
                    child: ResponsiveColumn(
                      children: [
                        _buildAIAnalysisButton(context, aiProvider, timerProvider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, TimerProvider timerProvider, AIProvider aiProvider) {
    return Column(
      children: [
        // 期間選択タブ
        _buildPeriodTabs(),
        
        Expanded(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Row(
                children: [
                  // 左側: パフォーマンスとグラフ
                  ResponsiveExpanded(
                    flex: 2,
                    child: ResponsiveColumn(
                      children: [
                        _buildPerformanceHeader(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildFocusChart(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildKeyMetrics(),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 中央: 生産的時間
                  ResponsiveExpanded(
                    flex: 1,
                    child: ResponsiveColumn(
                      children: [
                        _buildProductiveHours(),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                        _buildSessionHeatmap(),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // 右側: AI分析ボタン
                  ResponsiveExpanded(
                    flex: 1,
                    child: ResponsiveColumn(
                      children: [
                        _buildAIAnalysisButton(context, aiProvider, timerProvider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodTabs() {
    return ResponsiveContainer(
      margin: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.getResponsiveSpacing(context, mobile: 4, tablet: 6, desktop: 8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPeriodTab(AnalyticsPeriod.day, '日'),
          _buildPeriodTab(AnalyticsPeriod.week, '週'),
          _buildPeriodTab(AnalyticsPeriod.month, '月'),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(AnalyticsPeriod period, String label) {
    final isSelected = _selectedPeriod == period;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.getResponsiveSpacing(context, mobile: 12, tablet: 16, desktop: 20),
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getSubtitleFontSize(context),
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceHeader() {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 ${_getPeriodText()}のパフォーマンス',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getTitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            AppLocalizations.of(context)!.analysisDescription,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusChart() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionHistory = timerProvider.state.sessionHistory;
    final period = _selectedPeriod;
    final avgMap = getAverageCompletionByPeriod(sessionHistory, _periodToString(period));
    // X軸ラベル生成
    List<String> labels;
    if (avgMap.length == 1) {
      labels = avgMap.keys.toList();
    } else if (period == AnalyticsPeriod.week) {
      labels = avgMap.keys.map((k) {
        final parts = k.split('-W');
        final year = int.tryParse(parts[0]);
        final week = int.tryParse(parts.length > 1 ? parts[1] : '');
        if (year == null || week == null) return k;
        final monday = DateTime.utc(year, 1, 1 + (week - 1) * 7);
        return formatWeekLabel(monday);
      }).toList();
    } else if (period == AnalyticsPeriod.month) {
      labels = avgMap.keys.map((k) {
        final parts = k.split('-');
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts.length > 1 ? parts[1] : '');
        if (year == null || month == null) return k;
        final firstDay = DateTime(year, month, 1);
        return formatMonthLabel(firstDay);
      }).toList();
    } else {
      labels = avgMap.keys.toList()..sort();
    }
    final data = labels.asMap().entries.map((e) => avgMap[avgMap.keys.toList()[e.key]] ?? 0.0).toList();
    final hasData = labels.isNotEmpty;
    
    return ResponsiveCard(
      child: hasData
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '集中度グラフ',
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              SizedBox(
                height: ResponsiveUtils.isIPad(context) ? 320 : 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: List.generate(labels.length, (i) {
                        return Column(
                          children: [
                            Container(
                              width: ResponsiveUtils.isIPad(context) ? 40 : 32,
                              height: (data[i] * 200).clamp(0, 200),
                              color: AppColors.primaryColor.withOpacity(0.7),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                            Text(
                              labels[i], 
                              style: GoogleFonts.notoSans(
                                fontSize: ResponsiveUtils.getCaptionFontSize(context), 
                                color: AppColors.textColor.withOpacity(0.7)
                              )
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              child: Text(
                AppLocalizations.of(context)!.noData, 
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getBodyFontSize(context), 
                  color: AppColors.textColor.withOpacity(0.5)
                )
              ),
            ),
          ),
    );
  }

  String _periodToString(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.day:
        return '日';
      case AnalyticsPeriod.week:
        return '週';
      case AnalyticsPeriod.month:
        return '月';
    }
  }

  Widget _buildKeyMetrics() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionHistory = timerProvider.state.sessionHistory;
    if (sessionHistory.isEmpty) {
      return ResponsiveCard(
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noData, 
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context), 
              color: AppColors.textColor.withOpacity(0.5)
            )
          ),
        ),
      );
    }
    final completed = sessionHistory.where((r) => r.wasCompleted).length;
    final total = sessionHistory.length;
    final avgFocus = sessionHistory.isNotEmpty ? sessionHistory.map((r) => r.actualDuration).reduce((a, b) => a + b) ~/ sessionHistory.length ~/ 60 : 0;
    final avgRate = sessionHistory.isNotEmpty ? (sessionHistory.map((r) => r.completionRate).reduce((a, b) => a + b) / sessionHistory.length * 100).toInt() : 0;
    final consecutive = _calculateConsecutiveDays(sessionHistory);
    
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎯 重要指標',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getSubtitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          _buildMetricRow('完了セッション', '$completed/$total', total > 0 ? '${(completed / total * 100).toInt()}%' : '0%'),
          _buildMetricRow('平均集中時間', '$avgFocus分', ''),
          _buildMetricRow('完了率', '$avgRate%', ''),
          _buildMetricRow('連続使用日数', '$consecutive日', consecutive > 0 ? '🔥' : ''),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String trend) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getBodyFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
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
                  trend,
                  style: GoogleFonts.notoSans(
                    fontSize: ResponsiveUtils.getCaptionFontSize(context),
                    color: AppColors.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateConsecutiveDays(List sessionHistory) {
    if (sessionHistory.isEmpty) return 0;
    final sorted = sessionHistory.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    int consecutive = 0;
    DateTime? lastDate;
    for (final r in sorted) {
      final d = DateTime(r.startTime.year, r.startTime.month, r.startTime.day);
      if (lastDate == null) {
        lastDate = d;
        consecutive = 1;
      } else if (lastDate.difference(d).inDays == 1) {
        consecutive++;
        lastDate = d;
      } else if (lastDate.isAtSameMomentAs(d)) {
        continue;
      } else {
        break;
      }
    }
    return consecutive;
  }

  Widget _buildProductiveHours() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionHistory = timerProvider.state.sessionHistory;
    if (sessionHistory.isEmpty) {
      return ResponsiveCard(
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noData, 
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context), 
              color: AppColors.textColor.withOpacity(0.5)
            )
          ),
        ),
      );
    }
    // 時間帯ごとの平均完了率を計算
    final Map<int, List<double>> hourMap = {};
    for (final r in sessionHistory) {
      final hour = r.startTime.hour;
      hourMap.putIfAbsent(hour, () => []).add(r.completionRate);
    }
    final hourAvg = hourMap.map((k, v) => MapEntry(k, v.isNotEmpty ? v.reduce((a, b) => a + b) / v.length : 0.0));
    final sorted = hourAvg.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⏰ 最も生産的な時間帯',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getSubtitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          if (sorted.isEmpty)
            Text(
              AppLocalizations.of(context)!.noData, 
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context), 
                color: AppColors.textColor.withOpacity(0.5)
              )
            ),
          ...sorted.take(3).map((e) => _buildProductiveHourRow(
            '${sorted.indexOf(e) + 1}位',
            '${e.key.toString().padLeft(2, '0')}:00-${(e.key + 2).toString().padLeft(2, '0')}:00',
            '${(e.value * 100).toInt()}%',
          )),
        ],
      ),
    );
  }

  Widget _buildProductiveHourRow(String rank, String time, String percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context)),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.isIPad(context) ? 40 : 32,
            height: ResponsiveUtils.isIPad(context) ? 40 : 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.isIPad(context) ? 20 : 16),
            ),
            child: Center(
              child: Text(
                rank,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getCaptionFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
          Expanded(
            child: Text(
              time,
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
                color: AppColors.textColor,
              ),
            ),
          ),
          Text(
            percentage,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppColors.successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionHeatmap() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionHistory = timerProvider.state.sessionHistory;
    if (sessionHistory.isEmpty) {
      return ResponsiveCard(
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noData, 
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context), 
              color: AppColors.textColor.withOpacity(0.5)
            )
          ),
        ),
      );
    }
    // 6-22時の各時間帯ごとのセッション数を集計
    final hours = List.generate(9, (i) => 6 + i * 2); // 6,8,10,...,22
    final Map<int, int> hourCount = { for (var h in hours) h: 0 };
    for (final r in sessionHistory) {
      final h = hours.lastWhere((hh) => r.startTime.hour >= hh, orElse: () => 6);
      hourCount[h] = (hourCount[h] ?? 0) + 1;
    }
    final maxCount = hourCount.values.isNotEmpty ? hourCount.values.reduce((a, b) => a > b ? a : b) : 1;
    
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎨 セッション分布',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getSubtitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Text(
            '時間別ヒートマップ',
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: AppColors.textColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Row(
            children: hours.map((hour) => Expanded(
              child: Text(
                hour.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getCaptionFontSize(context),
                  color: AppColors.textColor.withOpacity(0.6),
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          Row(
            children: hours.map((hour) {
              final count = hourCount[hour] ?? 0;
              final intensity = maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;
              return Expanded(
                child: Container(
                  height: ResponsiveUtils.isIPad(context) ? 24 : 20,
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context) / 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(intensity),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context) / 2),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisButton(BuildContext context, AIProvider aiProvider, TimerProvider timerProvider) {
    return Column(
      children: [
        _buildResetButton(context, timerProvider),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/ai-insights');
            },
            icon: Icon(
              Icons.psychology,
              size: ResponsiveUtils.getResponsiveIconSize(context),
            ),
            label: Text(
              '🤖 AI詳細分析を見る',
              style: TextStyle(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black12),
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(BuildContext context, TimerProvider timerProvider) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.delete_forever,
          size: ResponsiveUtils.getResponsiveIconSize(context),
        ),
        label: Text(
          AppLocalizations.of(context)!.resetAnalyticsData,
          style: GoogleFonts.notoSans(
            fontSize: ResponsiveUtils.getBodyFontSize(context),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context), 
            vertical: ResponsiveUtils.getResponsiveSpacing(context)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
          ),
        ),
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.resetDataConfirm,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getTitleFontSize(context),
                ),
              ),
              content: Text(
                AppLocalizations.of(context)!.resetDataWarning,
                style: GoogleFonts.notoSans(
                  fontSize: ResponsiveUtils.getBodyFontSize(context),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: GoogleFonts.notoSans(
                      fontSize: ResponsiveUtils.getBodyFontSize(context),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    AppLocalizations.of(context)!.reset,
                    style: GoogleFonts.notoSans(
                      fontSize: ResponsiveUtils.getBodyFontSize(context),
                    ),
                  ),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await timerProvider.clearSessionHistory();
            if (context.mounted) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.resetDataDone,
                    style: GoogleFonts.notoSans(
                      fontSize: ResponsiveUtils.getBodyFontSize(context),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  String _getPeriodText() {
    switch (_selectedPeriod) {
      case AnalyticsPeriod.day:
        return AppLocalizations.of(context)!.today;
      case AnalyticsPeriod.week:
        return AppLocalizations.of(context)!.thisWeek;
      case AnalyticsPeriod.month:
        return AppLocalizations.of(context)!.thisMonth;
    }
  }
} 