import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_timer_app/data/models/focus_pattern.dart';
import 'package:focus_timer_app/presentation/providers/ai_provider.dart';
import 'package:focus_timer_app/services/ai_service.dart';
import 'package:focus_timer_app/presentation/providers/timer_provider.dart';
import 'package:focus_timer_app/data/models/settings.dart';

class RejectNetwork extends HttpOverrides {
  int attempts = 0;
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    attempts++;
    throw StateError('Personal focus data must not be sent to a provider');
  }
}

void main() {
  testWidgets('core countdown works without remote AI', (tester) async {
    final network = RejectNetwork();
    HttpOverrides.global = network;
    addTearDown(() => HttpOverrides.global = null);
    final timer = TimerProvider(
      settings: Settings.defaultSettings().copyWith(soundEnabled: false),
    );
    final before = timer.state.remainingSeconds;
    timer.startTimer();
    await tester.pump(const Duration(seconds: 2));
    expect(timer.state.isRunning, isTrue);
    expect(timer.state.remainingSeconds, before - 2);
    expect(network.attempts, 0);
    timer.dispose();
  });

  test('full analysis finishes offline without exporting focus data', () async {
    final network = RejectNetwork();
    HttpOverrides.global = network;
    addTearDown(() => HttpOverrides.global = null);
    final input = <FocusPattern>[
      FocusPattern(
        id: 'private-session',
        timestamp: DateTime(2026, 10, 25),
        plannedDuration: 1500,
        actualDuration: 1200,
        taskType: 'work',
        taskCategory: 'private',
        productivityScore: 80,
        sessionTime: const TimeOfDay(hour: 10, minute: 0),
      ),
    ];
    final before = input.single.toJson();
    final provider = AIProvider();
    addTearDown(provider.dispose);
    await provider
        .performFullAnalysis(input)
        .timeout(const Duration(seconds: 2));
    expect(network.attempts, 0);
    expect(provider.isAnalyzing, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.currentAnalysis, isNull);
    expect(provider.insights, isEmpty);
    expect(provider.optimalTiming, isNull);
    expect(provider.productivityScore, 75);
    expect(input.single.toJson(), before);
  });

  test('repeated initialization needs no embedded credential', () async {
    final network = RejectNetwork();
    HttpOverrides.global = network;
    addTearDown(() => HttpOverrides.global = null);
    final service = AIService();
    await service.initialize();
    await service.initialize();
    expect(await service.analyzeFocusPatterns([]), isNull);
    expect(await service.predictOptimalTiming([]), isNull);
    expect(network.attempts, 0);
  });
}
