import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/pomodoro_state.dart';
import '../../data/models/focus_pattern.dart';

class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;

  // デバイスタイプの判定
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // デバイスタイプの取得
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < _mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < _tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // 画面サイズの取得
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // パディングの調整
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    }
  }

  // フォントサイズの調整
  static double getResponsiveFontSize(BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static double getTitleFontSize(BuildContext context) {
    return getResponsiveFontSize(
      context,
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  static double getSubtitleFontSize(BuildContext context) {
    return getResponsiveFontSize(
      context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  static double getBodyFontSize(BuildContext context) {
    return getResponsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
  }

  static double getCaptionFontSize(BuildContext context) {
    return getResponsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
  }

  // アイコンサイズの調整
  static double getResponsiveIconSize(BuildContext context, {
    double mobile = 24.0,
    double tablet = 28.0,
    double desktop = 32.0,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // カードの高さ調整
  static double getResponsiveCardHeight(BuildContext context, {
    double mobile = 120.0,
    double tablet = 140.0,
    double desktop = 160.0,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // グリッドの列数調整
  static int getResponsiveGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  // アスペクト比の調整
  static double getResponsiveAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.2;
    } else {
      return 1.5;
    }
  }

  // ボタンサイズの調整
  static Size getResponsiveButtonSize(BuildContext context) {
    if (isMobile(context)) {
      return const Size(120, 48);
    } else if (isTablet(context)) {
      return const Size(140, 56);
    } else {
      return const Size(160, 64);
    }
  }

  // スペーシングの調整
  static double getResponsiveSpacing(BuildContext context, {
    double mobile = 8.0,
    double tablet = 12.0,
    double desktop = 16.0,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // 最大幅の設定
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 800;
    }
  }

  // ランドスケープ対応
  static bool shouldUseCompactLayout(BuildContext context) {
    return isMobile(context) && isLandscape(context);
  }

  // セーフエリアの考慮
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

List<FocusPattern> toFocusPatternList(List<SessionRecord> records) {
  return records
      .where((record) => record.actualDuration >= 1)
      .map((record) => FocusPattern(
        id: record.id,
        timestamp: record.startTime,
        plannedDuration: record.plannedDuration,
        actualDuration: record.actualDuration,
        taskType: record.isWorkSession ? 'work' : 'break',
        taskCategory: '',
        productivityScore: record.completionRate,
        sessionTime: TimeOfDay.fromDateTime(record.startTime),
        interruptionTypes: const [],
        environmentNoise: 0.0,
        mood: 'neutral',
        energyLevel: 0.5,
        weather: null,
        metadata: const {},
        interruptions: record.interruptions,
      ))
      .toList();
}

/// 実績データのみ（completionRate>0）で日・週・月ごとにグループ化
Map<String, List<SessionRecord>> groupSessionsByPeriod(List<SessionRecord> records, String period) {
  final filtered = records.where((r) => r.completionRate > 0).toList();
  final Map<String, List<SessionRecord>> grouped = {};
  for (final r in filtered) {
    String key;
    if (period == '日') {
      key = DateFormat('yyyy-MM-dd').format(r.startTime);
    } else if (period == '週') {
      final weekStr = DateFormat('w').format(r.startTime);
      if (int.tryParse(weekStr) == null) continue; // 不正な週番号はスキップ
      final week = int.parse(weekStr);
      key = '${r.startTime.year}-W$week';
    } else if (period == '月') {
      final monthStr = DateFormat('MM').format(r.startTime);
      if (int.tryParse(monthStr) == null) continue; // 不正な月番号はスキップ
      key = '${r.startTime.year}-$monthStr';
    } else {
      key = DateFormat('yyyy-MM-dd').format(r.startTime);
    }
    grouped.putIfAbsent(key, () => []).add(r);
  }
  return grouped;
}

/// 期間ごとの平均完了率を返す（グラフ用）
Map<String, double> getAverageCompletionByPeriod(List<SessionRecord> records, String period) {
  final grouped = groupSessionsByPeriod(records, period);
  final Map<String, double> result = {};
  grouped.forEach((key, sessions) {
    final avg = sessions.isNotEmpty
      ? sessions.map((r) => r.completionRate).reduce((a, b) => a + b) / sessions.length
      : 0.0;
    result[key] = avg;
  });
  return result;
}

/// 週グラフ用: 日付＋曜日ラベル（例: 6/10(月)）
String formatWeekLabel(DateTime date) {
  const youbi = ['日', '月', '火', '水', '木', '金', '土'];
  return '${date.month}/${date.day}(${youbi[date.weekday % 7]})';
}

/// 月グラフ用: 月/日ラベル（例: 6/10）
String formatMonthLabel(DateTime date) {
  return '${date.month}/${date.day}';
} 