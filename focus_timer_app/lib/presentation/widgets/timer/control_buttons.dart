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
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // メインボタン（開始/一時停止/再開）
          Expanded(
            flex: 2,
            child: _buildMainButton(context),
          ),
          
          const SizedBox(height: 8),
          
          // サブボタン（リセット/スキップ）
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildSubButton(
                    context,
                    icon: Icons.refresh,
                    label: 'リセット',
                    onTap: onReset,
                    color: AppColors.errorColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSubButton(
                    context,
                    icon: Icons.skip_next,
                    label: 'スキップ',
                    onTap: onSkip,
                    color: AppColors.warningColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(BuildContext context) {
    if (state.isInitial) {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '開始',
        onTap: onStart,
        color: state.sessionColor,
      );
    } else if (state.isRunning) {
      return _buildLargeButton(
        context,
        icon: Icons.pause,
        label: '一時停止',
        onTap: onPause,
        color: state.sessionColor,
      );
    } else if (state.isPaused) {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '再開',
        onTap: onResume,
        color: state.sessionColor,
      );
    } else {
      return _buildLargeButton(
        context,
        icon: Icons.play_arrow,
        label: '開始',
        onTap: onStart,
        color: state.sessionColor,
      );
    }
  }

  Widget _buildLargeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
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
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 16,
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
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
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 