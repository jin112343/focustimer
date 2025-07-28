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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
    
    final iconSize = isSmallScreen ? 28.0 : isMediumScreen ? 32.0 : 36.0;
    final fontSize = isSmallScreen ? 16.0 : isMediumScreen ? 18.0 : 20.0;
    final margin = isSmallScreen ? 4.0 : isMediumScreen ? 5.0 : 6.0;
    final spacing = isSmallScreen ? 8.0 : 10.0;

    return Column(
      children: [
        // ポモドーロアイコン
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPomodoros, (index) {
            final isCompleted = index < completedPomodoros;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: margin),
              child: Icon(
                isCompleted ? Icons.circle : Icons.circle_outlined,
                color: isCompleted ? AppColors.workColor : AppColors.textColor.withValues(alpha: 0.3),
                size: iconSize,
              ),
            );
          }),
        ),
        
        SizedBox(height: spacing),
        
        // カウンター表示
        Text(
          '($completedPomodoros/$totalPomodoros)',
          style: GoogleFonts.notoSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}