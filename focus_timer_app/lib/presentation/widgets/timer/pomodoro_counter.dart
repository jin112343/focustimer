import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class PomodoroCounter extends StatelessWidget {
  final int completedPomodoros;
  final int totalPomodoros;

  const PomodoroCounter({
    super.key,
    required this.completedPomodoros,
    required this.totalPomodoros,
  });

// pomodoro_counter.dart の修正
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,  // この行を追加
          children: [
            // ポモドーロアイコン
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPomodoros, (index) {
                final isCompleted = index < completedPomodoros;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isCompleted ? Icons.circle : Icons.circle_outlined,
                    color: isCompleted ? AppColors.workColor : AppColors.textColor.withValues(alpha: 0.3),
                    size: 16,  // 20から16に削減
                  ),
                );
              }),
            ),

            const SizedBox(height: 4),  // 8から4に削減

            // カウンター表示
            Text(
              '($completedPomodoros/$totalPomodoros)',
              style: GoogleFonts.notoSans(
                fontSize: 14,  // 16から14に削減
                fontWeight: FontWeight.w600,
                color: AppColors.textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}