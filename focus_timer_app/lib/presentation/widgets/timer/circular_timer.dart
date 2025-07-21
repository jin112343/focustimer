import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/pomodoro_state.dart';
import '../../../data/models/settings.dart';

class CircularTimer extends StatelessWidget {
  final PomodoroState state;
  final Settings settings;

  const CircularTimer({
    super.key,
    required this.state,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
    
    // 画面サイズに応じたサイズ調整
    final radius = isSmallScreen ? 80.0 : isMediumScreen ? 100.0 : 120.0;
    final lineWidth = isSmallScreen ? 8.0 : isMediumScreen ? 10.0 : 12.0;
    final timeFontSize = isSmallScreen ? 32.0 : isMediumScreen ? 40.0 : 48.0;
    final sessionTypeFontSize = isSmallScreen ? 14.0 : isMediumScreen ? 16.0 : 18.0;
    final centerSpacing = isSmallScreen ? 4.0 : 8.0;

    return Column(
      children: [
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: state.progressPercentage,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.formattedTime,
                style: GoogleFonts.robotoMono(
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.bold,
                  color: state.sessionColor,
                ),
              ),
              SizedBox(height: centerSpacing),
              Text(
                state.sessionTypeText,
                style: GoogleFonts.notoSans(
                  fontSize: sessionTypeFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          progressColor: state.sessionColor,
          backgroundColor: state.sessionColor.withValues(alpha: 0.2),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 300,
        ),
      ],
    );
  }
} 