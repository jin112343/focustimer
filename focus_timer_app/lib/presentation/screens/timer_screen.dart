import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/timer/circular_timer.dart';
import '../widgets/timer/control_buttons.dart';
import '../widgets/timer/pomodoro_counter.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_insights_screen.dart';
import '../../core/constants/colors.dart';
import '../../data/models/pomodoro_state.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
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