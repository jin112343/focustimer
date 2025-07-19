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

  @override
  Widget build(BuildContext context) {
    return Column(
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
                size: 24,
              ),
            );
          }),
        ),
        
        const SizedBox(height: 8),
        
        // カウンター表示
        Text(
          '($completedPomodoros/$totalPomodoros)',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
} 