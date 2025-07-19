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
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 12.0,
          percent: state.progressPercentage,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.formattedTime,
                style: GoogleFonts.robotoMono(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: state.sessionColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.sessionTypeText,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
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