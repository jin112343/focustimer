import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you'll need to edit this
/// file.
///
/// First, open your project's ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project's Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Timer AI'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @timerSettings.
  ///
  /// In en, this message translates to:
  /// **'Timer Settings'**
  String get timerSettings;

  /// No description provided for @soundAndNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sound & Notifications'**
  String get soundAndNotifications;

  /// No description provided for @aiFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get aiFeatures;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @autoStart.
  ///
  /// In en, this message translates to:
  /// **'Auto Start'**
  String get autoStart;

  /// No description provided for @alarmSound.
  ///
  /// In en, this message translates to:
  /// **'Alarm Sound'**
  String get alarmSound;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Data is anonymized and processed in a way that cannot identify individuals.'**
  String get dataCollectionDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @confirmReset.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset all settings to default?'**
  String get confirmReset;

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @aiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'AI Suggestion'**
  String get aiSuggestion;

  /// No description provided for @seeFullAIAnalysis.
  ///
  /// In en, this message translates to:
  /// **'See Full AI Analysis'**
  String get seeFullAIAnalysis;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your feedback to improve the app'**
  String get feedbackSubtitle;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'About data handling'**
  String get privacyPolicySubtitle;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @analysisDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the result of analyzing your focus pattern'**
  String get analysisDescription;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @resetAnalyticsData.
  ///
  /// In en, this message translates to:
  /// **'Reset analytics data'**
  String get resetAnalyticsData;

  /// No description provided for @resetDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset Data Confirmation'**
  String get resetDataConfirm;

  /// No description provided for @resetDataWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all analytics and graph data? This action cannot be undone.'**
  String get resetDataWarning;

  /// No description provided for @resetDataDone.
  ///
  /// In en, this message translates to:
  /// **'Analytics and graph data has been reset'**
  String get resetDataDone;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI analyzing...'**
  String get aiAnalyzing;

  /// No description provided for @aiWaiting.
  ///
  /// In en, this message translates to:
  /// **'AI waiting'**
  String get aiWaiting;

  /// No description provided for @noAIData.
  ///
  /// In en, this message translates to:
  /// **'No AI analysis data available'**
  String get noAIData;

  /// No description provided for @aiRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh AI analysis'**
  String get aiRefresh;

  /// No description provided for @bestFocusTime.
  ///
  /// In en, this message translates to:
  /// **'The best focus time today is {time}'**
  String bestFocusTime(Object time);

  /// No description provided for @aiDetailAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Detailed Analysis'**
  String get aiDetailAnalysis;

  /// No description provided for @todayOptimalTiming.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Optimal Timing'**
  String get todayOptimalTiming;

  /// No description provided for @todayOptimalTimingDescription.
  ///
  /// In en, this message translates to:
  /// **'Based on your past data, the best focus time is {start} to {end}. Place important tasks in this period.'**
  String todayOptimalTimingDescription(Object end, Object start);

  /// No description provided for @confidenceLevel.
  ///
  /// In en, this message translates to:
  /// **'Confidence Level'**
  String get confidenceLevel;

  /// No description provided for @confidenceLevelDescription.
  ///
  /// In en, this message translates to:
  /// **'The confidence level of this analysis is {confidence}%'**
  String confidenceLevelDescription(Object confidence);

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action'**
  String get recommendedAction;

  /// No description provided for @noAIRecommendedAction.
  ///
  /// In en, this message translates to:
  /// **'No AI recommended action'**
  String get noAIRecommendedAction;

  /// No description provided for @otherAIInsights.
  ///
  /// In en, this message translates to:
  /// **'Other AI Insights'**
  String get otherAIInsights;

  /// No description provided for @seeFullAIReport.
  ///
  /// In en, this message translates to:
  /// **'See Full AI Analysis'**
  String get seeFullAIReport;

  /// No description provided for @ai.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get ai;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @personalizedAdvice.
  ///
  /// In en, this message translates to:
  /// **'Personalized Advice'**
  String get personalizedAdvice;

  /// No description provided for @aiAnalysisResult.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis Result'**
  String get aiAnalysisResult;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdated(Object time);

  /// No description provided for @noAnalysisData.
  ///
  /// In en, this message translates to:
  /// **'No analysis data'**
  String get noAnalysisData;

  /// No description provided for @optimalTimingPrediction.
  ///
  /// In en, this message translates to:
  /// **'Optimal Timing Prediction'**
  String get optimalTimingPrediction;

  /// No description provided for @recommendedSchedule.
  ///
  /// In en, this message translates to:
  /// **'Recommended Schedule:'**
  String get recommendedSchedule;

  /// No description provided for @predictedSessions.
  ///
  /// In en, this message translates to:
  /// **'Predicted sessions: {count}'**
  String predictedSessions(Object count);

  /// No description provided for @habitFormationProgress.
  ///
  /// In en, this message translates to:
  /// **'Habit Formation Progress'**
  String get habitFormationProgress;

  /// No description provided for @consecutiveUsage.
  ///
  /// In en, this message translates to:
  /// **'Consecutive usage: {days} days'**
  String consecutiveUsage(Object days);

  /// No description provided for @weeklyGoalAchievement.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal achievement: {percent}%'**
  String weeklyGoalAchievement(Object percent);

  /// No description provided for @nextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone: {milestone} days, {remaining} days left'**
  String nextMilestone(Object milestone, Object remaining);

  /// No description provided for @actionableActions.
  ///
  /// In en, this message translates to:
  /// **'Actionable Actions:'**
  String get actionableActions;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @timerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Timer display, {minutes}:{seconds} remaining'**
  String timerDisplay(Object minutes, Object seconds);

  /// No description provided for @currentSessionRemainingTime.
  ///
  /// In en, this message translates to:
  /// **'Showing remaining time for current session'**
  String get currentSessionRemainingTime;

  /// No description provided for @concentrationTrend.
  ///
  /// In en, this message translates to:
  /// **'Concentration trend ({period})'**
  String concentrationTrend(Object period);

  /// No description provided for @noConcentrationData.
  ///
  /// In en, this message translates to:
  /// **'No valid AI analysis data for {period} unit concentration graph'**
  String noConcentrationData(Object period);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
