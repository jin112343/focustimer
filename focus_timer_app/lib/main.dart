import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/providers/timer_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/ai_provider.dart';
import 'presentation/screens/timer_screen.dart';
import 'data/models/settings.dart';
import 'core/constants/colors.dart';

void main() {
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
      child: MaterialApp(
        title: 'Focus Timer AI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        ),
        home: const TimerScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
