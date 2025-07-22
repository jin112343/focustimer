import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/providers/timer_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/ai_provider.dart';
import 'presentation/screens/timer_screen.dart';
import 'presentation/screens/ai_insights_screen.dart';
import 'data/models/settings.dart';
import 'presentation/theme/app_theme.dart';
import 'core/constants/colors.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 起動時間最適化のための設定
  WidgetsFlutterBinding.ensureInitialized();

  // フォントの事前読み込み
  GoogleFonts.pendingFonts([
    GoogleFonts.notoSans(),
  ]);

  runApp(const FocusTimerApp());
}

class FocusTimerApp extends StatelessWidget {
  const FocusTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(
            initialSettings: Settings.defaultSettings(),
          ),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, TimerProvider>(
          create: (context) => TimerProvider(
            settings: context.read<SettingsProvider>().settings,
          ),
          update: (context, settingsProvider, previous) => TimerProvider(
            settings: settingsProvider.settings,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AIProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final settings = context.watch<SettingsProvider>().settings;
          return MaterialApp(
            title: 'Focus Timer AI',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settings.preferredLanguage == 'en'
                ? const Locale('en')
                : const Locale('ja'),
            home: Container(
              color: AppColors.backgroundColor,
              child: const TimerScreen(),
            ),
            routes: {
              '/ai-insights': (context) => const AIInsightsScreen(),
            },
          );
        },
      ),
    );
  }
}
