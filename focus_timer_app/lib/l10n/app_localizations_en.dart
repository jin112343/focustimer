// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Focus Timer AI';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get timerSettings => 'Timer Settings';

  @override
  String get soundAndNotifications => 'Sound & Notifications';

  @override
  String get aiFeatures => 'AI Features';

  @override
  String get others => 'Others';

  @override
  String get language => 'Language';

  @override
  String get version => 'Version';

  @override
  String get feedback => 'Send Feedback';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get autoStart => 'Auto Start';

  @override
  String get alarmSound => 'Alarm Sound';

  @override
  String get volume => 'Volume';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataCollectionDescription => 'Data is anonymized and processed in a way that cannot identify individuals.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get confirmReset => 'Do you want to reset all settings to default?';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get aiSuggestion => 'AI Suggestion';

  @override
  String get seeFullAIAnalysis => 'See Full AI Analysis';

  @override
  String get close => 'Close';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get noData => 'No data available';

  @override
  String get darkModeSubtitle => 'Eye-friendly night mode';

  @override
  String get feedbackSubtitle => 'We appreciate your feedback to improve the app';

  @override
  String get privacyPolicySubtitle => 'About data handling';

  @override
  String get analytics => 'Analytics';

  @override
  String get analysisDescription => 'This is the result of analyzing your focus pattern';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get resetAnalyticsData => 'Reset analytics data';

  @override
  String get resetDataConfirm => 'Reset Data Confirmation';

  @override
  String get resetDataWarning => 'Are you sure you want to reset all analytics and graph data? This action cannot be undone.';

  @override
  String get resetDataDone => 'Analytics and graph data has been reset';

  @override
  String get aiAnalyzing => 'AI analyzing...';

  @override
  String get aiWaiting => 'AI waiting';

  @override
  String get noAIData => 'No AI analysis data available';

  @override
  String get aiRefresh => 'Refresh AI analysis';

  @override
  String bestFocusTime(Object time) {
    return 'The best focus time today is $time';
  }

  @override
  String get aiDetailAnalysis => 'AI Detailed Analysis';

  @override
  String get todayOptimalTiming => 'Today\'s Optimal Timing';

  @override
  String todayOptimalTimingDescription(Object end, Object start) {
    return 'Based on your past data, the best focus time is $start to $end. Place important tasks in this period.';
  }

  @override
  String get confidenceLevel => 'Confidence Level';

  @override
  String confidenceLevelDescription(Object confidence) {
    return 'The confidence level of this analysis is $confidence%';
  }

  @override
  String get recommendedAction => 'Recommended Action';

  @override
  String get noAIRecommendedAction => 'No AI recommended action';

  @override
  String get otherAIInsights => 'Other AI Insights';

  @override
  String get seeFullAIReport => 'See Full AI Analysis';

  @override
  String get ai => 'AI';

  @override
  String get work => 'Work';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get personalizedAdvice => 'Personalized Advice';

  @override
  String get aiAnalysisResult => 'AI Analysis Result';

  @override
  String lastUpdated(Object time) {
    return 'Last updated: $time';
  }

  @override
  String get noAnalysisData => 'No analysis data';

  @override
  String get optimalTimingPrediction => 'Optimal Timing Prediction';

  @override
  String get recommendedSchedule => 'Recommended Schedule:';

  @override
  String predictedSessions(Object count) {
    return 'Predicted sessions: $count';
  }

  @override
  String get habitFormationProgress => 'Habit Formation Progress';

  @override
  String consecutiveUsage(Object days) {
    return 'Consecutive usage: $days days';
  }

  @override
  String weeklyGoalAchievement(Object percent) {
    return 'Weekly goal achievement: $percent%';
  }

  @override
  String nextMilestone(Object milestone, Object remaining) {
    return 'Next milestone: $milestone days, $remaining days left';
  }

  @override
  String get actionableActions => 'Actionable Actions:';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes minutes ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String timerDisplay(Object minutes, Object seconds) {
    return 'Timer display, $minutes:$seconds remaining';
  }

  @override
  String get currentSessionRemainingTime => 'Showing remaining time for current session';

  @override
  String concentrationTrend(Object period) {
    return 'Concentration trend ($period)';
  }

  @override
  String noConcentrationData(Object period) {
    return 'No valid AI analysis data for $period unit concentration graph';
  }
}
