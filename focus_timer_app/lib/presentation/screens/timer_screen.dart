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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isSmallScreen = screenWidth < 400;
            final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
            final isLargeScreen = screenWidth >= 600;

            return Consumer2<TimerProvider, SettingsProvider>(
              builder: (context, timerProvider, settingsProvider, child) {
                final state = timerProvider.state;
                final settings = settingsProvider.settings;

                return Column(
                  children: [
                    // ヘッダー
                    _buildHeader(context, state, isSmallScreen),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.7,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 円形タイマー
                                SizedBox(
                                  width: isSmallScreen 
                                    ? screenWidth * 0.7 
                                    : isMediumScreen 
                                      ? screenWidth * 0.6 
                                      : screenWidth * 0.5,
                                  height: isSmallScreen 
                                    ? screenWidth * 0.7 
                                    : isMediumScreen 
                                      ? screenWidth * 0.6 
                                      : screenWidth * 0.5,
                                  child: CircularTimer(
                                    state: state,
                                    settings: settings,
                                  ),
                                ),
                                
                                SizedBox(height: isSmallScreen ? 24 : 32),
                                
                                // ポモドーロカウンター
                                if (settings.showPomodoroCounter)
                                  PomodoroCounter(
                                    completedPomodoros: state.completedPomodoros,
                                    totalPomodoros: 4,
                                  ),
                                
                                SizedBox(height: isSmallScreen ? 24 : 32),
                                
                                // AI提案カード
                                if (settings.aiEnabled && settings.aiSuggestionsEnabled)
                                  _buildAIInsightCard(context, isSmallScreen),
                                
                                SizedBox(height: isSmallScreen ? 24 : 32),
                                
                                // コントロールボタン
                                ControlButtons(
                                  state: state,
                                  onStart: timerProvider.startTimer,
                                  onPause: timerProvider.pauseTimer,
                                  onResume: timerProvider.resumeTimer,
                                  onReset: timerProvider.resetTimer,
                                  onSkip: timerProvider.skipSession,
                                ),
                                
                                SizedBox(height: isSmallScreen ? 32 : 48),
                                
                                // ナビゲーション
                                _buildNavigation(context, isSmallScreen),
                              ],
                            ),
                          ),
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

  Widget _buildHeader(BuildContext context, PomodoroState state, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: Colors.white,
            size: isSmallScreen ? 20 : 24,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🧠 Focus Timer AI',
                  style: GoogleFonts.notoSans(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'AI分析中 🔄',
                  style: GoogleFonts.notoSans(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12, 
              vertical: isSmallScreen ? 4 : 6
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              state.statusText,
              style: GoogleFonts.notoSans(
                fontSize: isSmallScreen ? 10 : 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
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
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            '今日は朝9時が最も集中できる時間です',
            style: GoogleFonts.notoSans(
              fontSize: isSmallScreen ? 12 : 14,
              color: AppColors.textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
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
            // TODO: 統計画面に遷移
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
          horizontal: isSmallScreen ? 12 : 16, 
          vertical: isSmallScreen ? 8 : 12
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
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
              size: isSmallScreen ? 20 : 24,
            ),
            SizedBox(height: isSmallScreen ? 2 : 4),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: isSmallScreen ? 10 : 12,
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