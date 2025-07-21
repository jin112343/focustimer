import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/pomodoro_state.dart';

class ControlButtons extends StatelessWidget {
  final PomodoroState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const ControlButtons({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    return Column(
      children: [
        // メインボタン（開始/一時停止/再開）
        _buildMainButton(context, isSmallScreen, isMediumScreen),
        
        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
        
        // サブボタン（リセット/スキップ）
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSubButton(
              context,
              icon: Icons.refresh,
              label: 'リセット',
              onTap: onReset,
              color: AppColors.errorColor,
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(width: isSmallScreen ? 12.0 : 16.0),
            _buildSubButton(
              context,
              icon: Icons.skip_next,
              label: 'スキップ',
              onTap: onSkip,
              color: AppColors.warningColor,
              isSmallScreen: isSmallScreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainButton(BuildContext context, bool isSmallScreen, bool isMediumScreen) {
    if (state.isInitial) {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '開始',
        onTap: onStart,
        color: state.sessionColor,
        isSmallScreen: isSmallScreen,
        isMediumScreen: isMediumScreen,
      );
    } else if (state.isRunning) {
      return _buildLargeButton(
        context,
        icon: Icons.pause,
        label: '一時停止',
        onTap: onPause,
        color: state.sessionColor,
        isSmallScreen: isSmallScreen,
        isMediumScreen: isMediumScreen,
      );
    } else if (state.isPaused) {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '再開',
        onTap: onResume,
        color: state.sessionColor,
        isSmallScreen: isSmallScreen,
        isMediumScreen: isMediumScreen,
      );
    } else {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '開始',
        onTap: onStart,
        color: state.sessionColor,
        isSmallScreen: isSmallScreen,
        isMediumScreen: isMediumScreen,
      );
    }
  }

  Widget _buildLargeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required bool isSmallScreen,
    required bool isMediumScreen,
  }) {
    final buttonWidth = isSmallScreen ? 160.0 : isMediumScreen ? 180.0 : 200.0;
    final buttonHeight = isSmallScreen ? 48.0 : isMediumScreen ? 54.0 : 60.0;
    final iconSize = isSmallScreen ? 22.0 : isMediumScreen ? 25.0 : 28.0;
    final fontSize = isSmallScreen ? 16.0 : isMediumScreen ? 17.0 : 18.0;
    final borderRadius = isSmallScreen ? 24.0 : isMediumScreen ? 27.0 : 30.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
            SizedBox(width: isSmallScreen ? 6.0 : 8.0),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required bool isSmallScreen,
  }) {
    final padding = isSmallScreen 
      ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
      : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;
    final spacing = isSmallScreen ? 4.0 : 6.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(isSmallScreen ? 16.0 : 20.0),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            SizedBox(width: spacing),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 