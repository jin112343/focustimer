import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/pomodoro_state.dart';
import '../../../data/models/settings.dart';

class CircularTimer extends StatefulWidget {
  final PomodoroState state;
  final Settings settings;

  const CircularTimer({
    super.key,
    required this.state,
    required this.settings,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  int? _lastTotalSeconds;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController?.dispose();
    final totalSeconds = _getTotalSecondsForSession(widget.state.currentSession);
    _lastTotalSeconds = totalSeconds;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalSeconds),
    );
    if (widget.state.isRunning) {
      final elapsed = totalSeconds - widget.state.remainingSeconds;
      _animationController!.value = elapsed / totalSeconds;
      _animationController!.forward(from: _animationController!.value);
    } else {
      _animationController!.value = (totalSeconds - widget.state.remainingSeconds) / totalSeconds;
      _animationController!.stop();
    }
  }

  @override
  void didUpdateWidget(CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final totalSeconds = _getTotalSecondsForSession(widget.state.currentSession);
    if (_lastTotalSeconds != totalSeconds) {
      _initAnimation();
    } else if (widget.state.isRunning && !_animationController!.isAnimating) {
      _animationController!.forward();
    } else if (!widget.state.isRunning && _animationController!.isAnimating) {
      _animationController!.stop();
    }
    // タイマーがリセットされた場合
    if (widget.state.isInitial) {
      _animationController!.value = 0.0;
      _animationController!.stop();
    }
    // タイマーが完了した場合
    if (widget.state.isFinished) {
      _animationController!.value = 1.0;
      _animationController!.stop();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  int _getTotalSecondsForSession(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return widget.settings.workDurationSeconds;
      case SessionType.shortBreak:
        return widget.settings.shortBreakDurationSeconds;
      case SessionType.longBreak:
        return widget.settings.longBreakDurationSeconds;
    }
  }

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
          percent: widget.state.progressPercentage,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.state.formattedTime,
                style: GoogleFonts.robotoMono(
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.state.sessionColor,
                ),
              ),
              SizedBox(height: centerSpacing),
              Text(
                widget.state.sessionTypeText,
                style: GoogleFonts.notoSans(
                  fontSize: sessionTypeFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          linearGradient: const LinearGradient(
            colors: [
              Color(0xFF00c5fc), // 水色
              Color(0xFF0032ff), // 青
              Color(0xFFff00a6), // 赤
              Color(0xFF7b02b3), // 紫
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: Colors.white,
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
        ),
      ],
    );
  }
} 