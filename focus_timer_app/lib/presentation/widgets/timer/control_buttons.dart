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
        
        SizedBox(height: isSmallScreen ? 16.0 : 20.0),
        
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
            SizedBox(width: isSmallScreen ? 16.0 : 20.0),
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
    final buttonWidth = isSmallScreen ? 200.0 : isMediumScreen ? 240.0 : 280.0;
    final buttonHeight = isSmallScreen ? 60.0 : isMediumScreen ? 68.0 : 76.0;
    final iconSize = isSmallScreen ? 28.0 : isMediumScreen ? 32.0 : 36.0;
    final fontSize = isSmallScreen ? 18.0 : isMediumScreen ? 20.0 : 22.0;
    final borderRadius = isSmallScreen ? 30.0 : isMediumScreen ? 34.0 : 38.0;

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
            SizedBox(width: isSmallScreen ? 8.0 : 10.0),
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
      ? const EdgeInsets.symmetric(horizontal: 20, vertical: 14)
      : const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    final iconSize = isSmallScreen ? 22.0 : 24.0;
    final fontSize = isSmallScreen ? 14.0 : 16.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 24.0),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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