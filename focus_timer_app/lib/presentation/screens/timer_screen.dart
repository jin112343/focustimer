import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/ai_provider.dart';
import '../widgets/timer/circular_timer.dart';
import '../widgets/timer/control_buttons.dart';
import '../widgets/timer/pomodoro_counter.dart';
import '../widgets/common/accessibility_wrapper.dart';
import '../widgets/common/modern_card.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_insights_screen.dart';
import '../screens/analytics_screen.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/pomodoro_state.dart';
import '../../data/models/settings.dart';
import '../../data/models/focus_pattern.dart';
import '../../core/utils/responsive_utils.dart';
import '../../l10n/app_localizations.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<TimerProvider, SettingsProvider, AIProvider>(
      builder: (context, timerProvider, settingsProvider, aiProvider, child) {
        final state = timerProvider.state;
        final settings = settingsProvider.settings;
        final sessionHistory = state.sessionHistory;
        // より柔軟なレスポンシブ判定
        final width = MediaQuery.of(context).size.width;

        Widget layout;
        if (width < 600) {
          layout = _buildMobileLayout(context, state, settings, timerProvider, aiProvider);
        } else if (width < 1200) {
          layout = _buildTabletLayout(context, state, settings, timerProvider, aiProvider);
        } else {
          layout = _buildDesktopLayout(context, state, settings, timerProvider, aiProvider);
        }

        return layout;
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー（固定高さを削減）
            Container(
              height: 56,  // 60から56に削減
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildHeader(context, state),
            ),

            // メインコンテンツ（Expandedで残りのスペースを使用）
            Expanded(
              child: Column(
                children: [
                  // 円形タイマー（Expandedで柔軟な高さ）
                  Expanded(
                    flex: 3,  // 4から3に削減
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: AccessibilityWrapper(
                            label: AppLocalizations.of(context)!.timerDisplay(state.remainingMinutes, state.remainingSecondsDisplay.toString().padLeft(2, '0')),
                            hint: AppLocalizations.of(context)!.currentSessionRemainingTime,
                            child: CircularTimer(
                              state: state,
                              settings: settings,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ポモドーロカウンター（高さを調整）
                  if (settings.showPomodoroCounter)
                    Container(
                      height: 50,  // 40から50に増加
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PomodoroCounter(
                        completedPomodoros: state.completedPomodoros,
                        totalPomodoros: 4,
                      ),
                    ),

                  // AI提案カード（高さを自動調整）
                  if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _buildAIInsightCard(context, aiProvider),
                    ),

                  // コントロールボタン（Expandedで柔軟な高さ）
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ControlButtons(
                        state: state,
                        onStart: timerProvider.startTimer,
                        onPause: timerProvider.pauseTimer,
                        onResume: timerProvider.resumeTimer,
                        onReset: timerProvider.resetTimer,
                        onSkip: timerProvider.skipSession,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ナビゲーション（固定高さを削減）
            Container(
              height: 56,  // 60から56に削減
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),  // vertical paddingを追加
              child: _buildNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            // 左側: タイマーとコントロール
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 円形タイマー
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AccessibilityWrapper(
                          label: AppLocalizations.of(context)!.timerDisplay(state.remainingMinutes, state.remainingSecondsDisplay.toString().padLeft(2, '0')),
                          hint: AppLocalizations.of(context)!.currentSessionRemainingTime,
                          child: CircularTimer(
                            state: state,
                            settings: settings,
                          ),
                        ),
                      ),
                    ),

                    // ポモドーロカウンター
                    if (settings.showPomodoroCounter)
                      Container(
                        height: 40,
                        child: PomodoroCounter(
                          completedPomodoros: state.completedPomodoros,
                          totalPomodoros: 4,
                        ),
                      ),

                    // コントロールボタン
                    Container(
                      height: 100,
                      child: ControlButtons(
                        state: state,
                        onStart: timerProvider.startTimer,
                        onPause: timerProvider.pauseTimer,
                        onResume: timerProvider.resumeTimer,
                        onReset: timerProvider.resetTimer,
                        onSkip: timerProvider.skipSession,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 右側: ヘッダー、AI提案、ナビゲーション
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ヘッダー
                    _buildHeader(context, state),

                    const SizedBox(height: 16),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled) ...[
                      _buildAIInsightCard(context, aiProvider),
                      const SizedBox(height: 16),
                    ],

                    // ナビゲーション
                    Expanded(
                      child: Center(
                        child: _buildNavigation(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            // 左側: タイマーとコントロール
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 円形タイマー
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AccessibilityWrapper(
                          label: AppLocalizations.of(context)!.timerDisplay(state.remainingMinutes, state.remainingSecondsDisplay.toString().padLeft(2, '0')),
                          hint: AppLocalizations.of(context)!.currentSessionRemainingTime,
                          child: CircularTimer(
                            state: state,
                            settings: settings,
                          ),
                        ),
                      ),
                    ),

                    // ポモドーロカウンター
                    if (settings.showPomodoroCounter)
                      Container(
                        height: 50,
                        child: PomodoroCounter(
                          completedPomodoros: state.completedPomodoros,
                          totalPomodoros: 4,
                        ),
                      ),

                    // コントロールボタン
                    Container(
                      height: 120,
                      child: ControlButtons(
                        state: state,
                        onStart: timerProvider.startTimer,
                        onPause: timerProvider.pauseTimer,
                        onResume: timerProvider.resumeTimer,
                        onReset: timerProvider.resetTimer,
                        onSkip: timerProvider.skipSession,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 中央: ヘッダーとAI提案
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ヘッダー
                    _buildHeader(context, state),

                    const SizedBox(height: 24),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                      _buildAIInsightCard(context, aiProvider),
                  ],
                ),
              ),
            ),

            // 右側: ナビゲーション
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ナビゲーション
                    _buildNavigation(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PomodoroState state) {
    // セッション状態に応じたグラデーションを選択
    LinearGradient headerGradient;
    IconData headerIcon;
    String headerTitle;

    switch (state.currentSession) {
      case SessionType.work:
        headerGradient = AppColors.workGradient;
        headerIcon = Icons.work;
        headerTitle = AppLocalizations.of(context)!.work;
        break;
      case SessionType.shortBreak:
        headerGradient = AppColors.breakGradient;
        headerIcon = Icons.coffee;
        headerTitle = AppLocalizations.of(context)!.shortBreak;
        break;
      case SessionType.longBreak:
        headerGradient = AppColors.accentGradient;
        headerIcon = Icons.spa;
        headerTitle = AppLocalizations.of(context)!.longBreak;
        break;
    }

    // モバイルの場合はコンパクトなヘッダー
    if (ResponsiveUtils.isMobile(context)) {
      return Container(
        decoration: BoxDecoration(
          gradient: headerGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: state.sessionColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                headerIcon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,  // この行を追加
                  children: [
                    Flexible(  // Textの代わりにFlexibleでラップ
                      child: Text(
                        headerTitle,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.statusText,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // タブレット・デスクトップ用の通常のヘッダー
    return Container(
      decoration: BoxDecoration(
        gradient: headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: state.sessionColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                headerIcon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    headerTitle,
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isRunning ? AppLocalizations.of(context)!.aiAnalyzing : AppLocalizations.of(context)!.aiWaiting,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                state.statusText,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightCard(BuildContext context, AIProvider aiProvider) {
    final optimalTiming = aiProvider.optimalTiming;
    final isAnalyzing = aiProvider.isAnalyzing;
    final errorMessage = aiProvider.errorMessage;
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionHistory = timerProvider.state.sessionHistory;
    void _manualRefresh() {
      final focusPatterns = toFocusPatternList(sessionHistory);
      aiProvider.performFullAnalysis(focusPatterns);
    }
    if (isAnalyzing) {
      return ModernCard(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(errorMessage, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, duration: const Duration(seconds: 3)),
          );
        }
      });
      return ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(errorMessage, style: TextStyle(color: Colors.red)),
        ),
      );
    }
    if (optimalTiming == null) {
      return ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: Text(AppLocalizations.of(context)!.noAIData)),
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.accentColor),
                tooltip: AppLocalizations.of(context)!.aiRefresh,
                onPressed: _manualRefresh,
              ),
            ],
          ),
        ),
      );
    }
    return ModernCard(
      onTap: () => _showAIInsightDetails(context, aiProvider),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 12 : 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 8 : 12),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: AppColors.accentColor,
                size: ResponsiveUtils.isMobile(context) ? 20 : 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.aiSuggestion,
                        style: GoogleFonts.notoSans(
                          fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: AppColors.accentColor, size: 18),
                        tooltip: AppLocalizations.of(context)!.aiRefresh,
                        onPressed: _manualRefresh,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.bestFocusTime(optimalTiming.bestWorkTime.format(context)),
                      style: GoogleFonts.notoSans(
                        fontSize: ResponsiveUtils.isMobile(context) ? 12 : 14,
                        color: AppColors.textColor.withValues(alpha: 0.8),
                      ),
                      maxLines: ResponsiveUtils.isMobile(context) ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accentColor,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAIInsightDetails(BuildContext context, AIProvider aiProvider) {
    final optimalTiming = aiProvider.optimalTiming;
    final insights = aiProvider.insights;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ハンドル
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.psychology,
                            color: AppColors.aiPrimaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.aiDetailAnalysis,
                            style: GoogleFonts.notoSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (optimalTiming != null) ...[
                        _buildDetailSection(
                          AppLocalizations.of(context)!.todayOptimalTiming,
                          AppLocalizations.of(context)!.todayOptimalTimingDescription(optimalTiming.bestWorkTime.format(context), optimalTiming.bestBreakTime.format(context)),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailSection(
                          AppLocalizations.of(context)!.confidenceLevel,
                          AppLocalizations.of(context)!.confidenceLevelDescription(optimalTiming.confidenceLevel * 100),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailSection(
                          AppLocalizations.of(context)!.recommendedAction,
                          optimalTiming.aiReasoning.isNotEmpty ? optimalTiming.aiReasoning : AppLocalizations.of(context)!.noAIRecommendedAction,
                        ),
                      ],
                      if (insights.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.otherAIInsights, style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
                        ...insights.map((insight) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _buildDetailSection(insight.title, insight.description),
                        )),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('/ai-insights');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.aiPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.seeFullAIReport,
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppColors.textColor.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            context,
            icon: Icons.bar_chart,
            label: 'analytics',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
          ),
          _buildNavButton(
            context,
            icon: Icons.psychology,
            label: 'ai',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AIInsightsScreen(),
                ),
              );
            },
          ),
          _buildNavButton(
            context,
            icon: Icons.settings,
            label: 'settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(
            context,
            icon: Icons.bar_chart,
            label: 'analytics',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          _buildNavButton(
            context,
            icon: Icons.psychology,
            label: 'ai',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AIInsightsScreen(),
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          _buildNavButton(
            context,
            icon: Icons.settings,
            label: 'settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      );
    }
  }

  Widget _buildNavButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    // ラベルに応じて色を選択
    final l10n = AppLocalizations.of(context)!;
    Color buttonColor;
    switch (label) {
      case 'analytics':
        buttonColor = AppColors.secondaryColor;
        break;
      case 'settings':
        buttonColor = AppColors.accentColor;
        break;
      case 'ai':
        buttonColor = AppColors.primaryColor;
        break;
      default:
        buttonColor = AppColors.primaryColor;
    }

    // モバイルの場合はコンパクトなナビゲーションボタン
    if (ResponsiveUtils.isMobile(context)) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),  // vertical paddingを8から4に削減
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: buttonColor,
                size: 22,  // 24から22に削減
              ),
              const SizedBox(height: 2),  // 4から2に削減
              Text(
                label == 'analytics'
                    ? l10n.analytics
                    : label == 'settings'
                        ? l10n.settings
                        : label == 'ai'
                            ? l10n.ai
                            : label,
                style: GoogleFonts.notoSans(
                  fontSize: 11,  // 12から11に削減
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // タブレット・デスクトップ用の通常のナビゲーションボタン
    return ModernCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
            decoration: BoxDecoration(
              color: buttonColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
            ),
            child: Icon(
              icon,
              color: buttonColor,
              size: ResponsiveUtils.getResponsiveIconSize(context),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            label == 'analytics'
                ? l10n.analytics
                : label == 'settings'
                    ? l10n.settings
                    : label == 'ai'
                        ? l10n.ai
                        : label,
            style: GoogleFonts.notoSans(
              fontSize: ResponsiveUtils.getCaptionFontSize(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}