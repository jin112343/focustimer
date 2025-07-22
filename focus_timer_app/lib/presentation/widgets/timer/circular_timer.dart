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
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        final percent = _animationController!.value;
        final availableWidth = MediaQuery.of(context).size.width;
        final availableHeight = MediaQuery.of(context).size.height;
        final minDimension = availableWidth < availableHeight ? availableWidth : availableHeight;
        final radius = (minDimension - 40) / 2;
        final safeRadius = radius > 80 ? radius : 80.0;
        final lineWidth = safeRadius * 0.12;
        final fontSize = (safeRadius * 0.35).clamp(24.0, 48.0);
        final subtitleFontSize = (safeRadius * 0.15).clamp(14.0, 20.0);
        return Center(
          child: Container(
            width: safeRadius * 2,
            height: safeRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.state.sessionColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircularPercentIndicator(
              radius: safeRadius,
              lineWidth: lineWidth,
              percent: percent,
              center: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.state.formattedTime,
                        style: GoogleFonts.robotoMono(
                          fontSize: fontSize.clamp(3.0, safeRadius * 0.3),
                          fontWeight: FontWeight.bold,
                          color: widget.state.sessionColor,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: widget.state.sessionColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.state.sessionTypeText,
                          style: GoogleFonts.notoSans(
                            fontSize: subtitleFontSize.clamp(3.0, safeRadius * 0.12),
                            fontWeight: FontWeight.w600,
                            color: widget.state.sessionColor,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
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
          ),
        );
      },
    );
  }
} 