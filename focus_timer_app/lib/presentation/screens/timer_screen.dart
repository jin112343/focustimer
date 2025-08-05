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
import '../widgets/common/responsive_layout.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_insights_screen.dart';
import '../screens/analytics_screen.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/pomodoro_state.dart';
import '../../data/models/settings.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ad_service.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<TimerProvider, SettingsProvider, AIProvider>(
      builder: (context, timerProvider, settingsProvider, aiProvider, child) {
        final state = timerProvider.state;
        final settings = settingsProvider.settings;

        return ResponsiveLayout(
          mobile: _buildMobileLayout(context, state, settings, timerProvider, aiProvider),
          tablet: _buildTabletLayout(context, state, settings, timerProvider, aiProvider),
          ipad: _buildIPadLayout(context, state, settings, timerProvider, aiProvider),
          desktop: _buildDesktopLayout(context, state, settings, timerProvider, aiProvider),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            _buildHeader(context, state),
            
            // メインコンテンツ
            Expanded(
              child: Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 円形タイマー
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          child: CircularTimer(
                            state: state,
                            settings: settings,
                          ),
                        ),
                      ),
                    ),
                    
                    // ポモドーロカウンター
                    if (settings.showPomodoroCounter)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: PomodoroCounter(
                            completedPomodoros: state.completedPomodoros,
                            totalPomodoros: 4,
                          ),
                        ),
                      ),
                    
                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: _buildAIInsightCard(context),
                        ),
                      ),
                    
                    // コントロールボタン
                    Expanded(
                      flex: 2,
                      child: Center(
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
                    
                    // ナビゲーション
                    Expanded(
                      flex: 1,
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
                padding: ResponsiveUtils.getResponsivePadding(context),
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
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ヘッダー
                    _buildHeader(context, state),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled) ...[
                      _buildAIInsightCard(context),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
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

  Widget _buildIPadLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: IPadLayout(
          child: Row(
            children: [
              // 左側: タイマーとコントロール (40%)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 円形タイマー
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: SizedBox(
                            width: ResponsiveUtils.getContentWidth(context) * 0.6,
                            height: ResponsiveUtils.getContentWidth(context) * 0.6,
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

                      // ポモドーロカウンター
                      if (settings.showPomodoroCounter)
                        Container(
                          height: 60,
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

              // 中央: AI提案とヘッダー (35%)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ヘッダー
                      _buildHeader(context, state),

                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

                      // AI提案カード
                      if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                        Expanded(
                          child: _buildAIInsightCard(context),
                        ),
                    ],
                  ),
                ),
              ),

              // 右側: ナビゲーション (25%)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context),
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
                padding: ResponsiveUtils.getResponsivePadding(context),
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
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ヘッダー
                    _buildHeader(context, state),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                      _buildAIInsightCard(context),
                  ],
                ),
              ),
            ),

            // 右側: ナビゲーション
            Expanded(
              flex: 1,
              child: Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
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
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final settings = settingsProvider.settings;
        
        // プレミアム版の場合は広告を非表示
        if (settings.isPremium) {
          return const SizedBox.shrink();
        }

        return FutureBuilder(
          future: AdService().loadBannerAd(),
          builder: (context, snapshot) {
            final adWidget = AdService().getBannerAdWidget();
            
            if (adWidget != null) {
              return Container(
                width: double.infinity,
                child: adWidget,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildAIInsightCard(BuildContext context) {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        // 個人に合わせたAI提案を生成
        String personalizedSuggestion = _generatePersonalizedSuggestion(aiProvider);
        
        return ResponsiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.aiPrimaryColor,
                    size: ResponsiveUtils.getResponsiveIconSize(context),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  Text(
                    'AI提案',
                    style: GoogleFonts.notoSans(
                      fontSize: ResponsiveUtils.getSubtitleFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              // スクロール可能なテキストエリア
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(2),
                  child: SingleChildScrollView(
                    child: Text(
                      personalizedSuggestion,
                      style: GoogleFonts.notoSans(
                        fontSize: ResponsiveUtils.getBodyFontSize(context),
                        color: AppColors.textColor.withValues(alpha: 0.8),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _generatePersonalizedSuggestion(AIProvider aiProvider) {
    final now = DateTime.now();
    final hour = now.hour;
    
    // AI分析データがある場合はそれを使用
    if (aiProvider.insights.isNotEmpty) {
      final latestInsight = aiProvider.insights.first;
      return latestInsight.description;
    }
    
    // 最適タイミングデータがある場合はそれを使用
    if (aiProvider.optimalTiming != null) {
      final timing = aiProvider.optimalTiming!;
      final bestHour = timing.bestWorkTime.hour;
      return '${bestHour}時が最も集中できる時間です。重要なタスクをこの時間に配置しましょう。過去のデータ分析によると、この時間帯に作業を開始すると、生産性が平均30%向上します。また、午前中は創造的なタスクに最適で、複雑な問題解決も効率的に行えます。';
    }
    
    // 生産性スコアがある場合はそれを使用
    if (aiProvider.productivityScore > 0) {
      if (aiProvider.productivityScore >= 80) {
        return '生産性が高い状態です。この調子で継続しましょう。現在の集中力レベルを維持するために、適度な休憩を挟みながら作業を続けることをお勧めします。';
      } else if (aiProvider.productivityScore >= 60) {
        return '生産性は良好です。さらに向上させるために短い休憩を挟みましょう。25分の集中セッションの後に5分の休憩を取ることで、集中力を維持できます。';
      } else {
        return '生産性を向上させるために、集中時間を短く設定してみましょう。15分の短いセッションから始めて、徐々に時間を延ばしていくことをお勧めします。';
      }
    }
    
    // 時間帯に基づいたデフォルト提案
    if (hour >= 6 && hour < 12) {
      return '朝の集中力が高い時間です。重要なタスクを優先しましょう。朝の時間は脳が最も活性化しているため、複雑な作業や創造的なタスクに最適です。';
    } else if (hour >= 12 && hour < 18) {
      return '午後の作業時間です。短い休憩を挟んで集中力を維持しましょう。午後は集中力が低下しやすい時間帯なので、適度な休憩が重要です。';
    } else if (hour >= 18 && hour < 22) {
      return '夕方の時間です。今日の成果を振り返り、明日の計画を立てましょう。一日の作業を整理して、明日への準備を整える時間です。';
    } else {
      return '夜の時間です。リラックスして明日に備えましょう。十分な休息を取ることで、明日の集中力が向上します。';
    }
  }

  Widget _buildNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(
          context,
          icon: Icons.bar_chart,
          label: '統計',
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
          icon: Icons.settings,
          label: '設定',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          context,
          icon: Icons.psychology,
          label: 'AI',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AIInsightsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final buttonSize = ResponsiveUtils.getResponsiveButtonSize(context);
    
    return GestureDetector(
      onTap: onTap,
      child: ResponsiveCard(
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: ResponsiveUtils.getResponsiveIconSize(context),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: ResponsiveUtils.getCaptionFontSize(context),
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}