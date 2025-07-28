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
import '../screens/settings_screen.dart';
import '../screens/ai_insights_screen.dart';
import '../screens/analytics_screen.dart';
import '../../core/constants/colors.dart';
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

            return Consumer2<TimerProvider, SettingsProvider>(
              builder: (context, timerProvider, settingsProvider, child) {
                final state = timerProvider.state;
                final settings = settingsProvider.settings;

                return Column(
                  children: [
                    // ヘッダー
                    _buildHeader(context, state, isSmallScreen),
                    
                    // メインコンテンツ - Expandedで残りのスペースを使用
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 円形タイマー - 画面の40%を使用
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: SizedBox(
                                  width: isSmallScreen 
                                    ? screenWidth * 0.8 
                                    : isMediumScreen 
                                      ? screenWidth * 0.7 
                                      : screenWidth * 0.6,
                                  height: isSmallScreen 
                                    ? screenWidth * 0.8 
                                    : isMediumScreen 
                                      ? screenWidth * 0.7 
                                      : screenWidth * 0.6,
                                  child: CircularTimer(
                                    state: state,
                                    settings: settings,
                                  ),
                                ),
                              ),
                            ),
                            
                            // ポモドーロカウンター - 画面の10%を使用
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
                            
                            // AI提案カード - 画面の10%を使用（小さく調整）
                            if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: _buildAIInsightCard(context, isSmallScreen),
                                ),
                              ),
                            
                            // コントロールボタン - 画面の20%を使用
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
                            
                            // ナビゲーション - 画面の10%を使用
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: _buildNavigation(context, isSmallScreen),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, PomodoroState state, Settings settings, TimerProvider timerProvider, AIProvider aiProvider) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
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
                    _buildHeader(context, state, isSmallScreen),

                    const SizedBox(height: 16),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled) ...[
                      _buildAIInsightCard(context, isSmallScreen),
                      const SizedBox(height: 16),
                    ],

                    // ナビゲーション
                    Expanded(
                      child: Center(
                        child: _buildNavigation(context, isSmallScreen),
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
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
                    _buildHeader(context, state, isSmallScreen),

                    const SizedBox(height: 24),

                    // AI提案カード
                    if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                      _buildAIInsightCard(context, isSmallScreen),
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
                    _buildNavigation(context, isSmallScreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PomodoroState state, bool isSmallScreen) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final settings = settingsProvider.settings;
        
        print('Building header...');
        print('Is premium: ${settings.isPremium}');
        
        // プレミアム版の場合は広告を非表示
        if (settings.isPremium) {
          print('Premium user, hiding ad');
          return const SizedBox.shrink();
        }

        return FutureBuilder(
          future: AdService().loadBannerAd(),
          builder: (context, snapshot) {
            print('FutureBuilder state: ${snapshot.connectionState}');
            if (snapshot.hasError) {
              print('FutureBuilder error: ${snapshot.error}');
            }
            
            final adWidget = AdService().getBannerAdWidget();
            print('Ad widget: ${adWidget != null ? 'available' : 'null'}');
            
            if (adWidget != null) {
              print('Returning ad widget');
              return Container(
                width: double.infinity,
                child: adWidget,
              );
            } else {
              print('No ad widget available, showing empty space');
              // 広告が読み込めない場合は何も表示しない
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildAIInsightCard(BuildContext context, bool isSmallScreen) {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        // 個人に合わせたAI提案を生成
        String personalizedSuggestion = _generatePersonalizedSuggestion(aiProvider);
        
        return Container(
          width: double.infinity,
          height: isSmallScreen ? 80 : 100, // 固定の高さを設定
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.aiPrimaryColor,
                    size: isSmallScreen ? 18 : 20,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'AI提案',
                    style: GoogleFonts.notoSans(
                      fontSize: isSmallScreen ? 13 : 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              // スクロール可能なテキストエリア
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true, // スクロールバーを常に表示
                  thickness: 4, // スクロールバーの太さ
                  radius: const Radius.circular(2), // スクロールバーの角丸
                  child: SingleChildScrollView(
                    child: Text(
                      personalizedSuggestion,
                      style: GoogleFonts.notoSans(
                        fontSize: isSmallScreen ? 13 : 15,
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

  Widget _buildNavigation(BuildContext context, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(
          context,
          icon: Icons.bar_chart,
          label: '統計',
          isSmallScreen: isSmallScreen,
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
          isSmallScreen: isSmallScreen,
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
          isSmallScreen: isSmallScreen,
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
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20, 
          vertical: isSmallScreen ? 12 : 16
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: isSmallScreen ? 28 : 32,
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: isSmallScreen ? 12 : 14,
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