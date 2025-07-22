import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class AppTheme {
  // ライトテーマ
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      surface: AppColors.cardColor,
      background: AppColors.backgroundColor,
    ),
    textTheme: GoogleFonts.notoSansTextTheme().copyWith(
      displayLarge: GoogleFonts.notoSans(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: AppColors.textColor,
      ),
      displayMedium: GoogleFonts.notoSans(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      displaySmall: GoogleFonts.notoSans(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      headlineLarge: GoogleFonts.notoSans(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      headlineSmall: GoogleFonts.notoSans(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.textColor,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.textColor,
      ),
      titleSmall: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textColor,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textColor,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textColor,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textColor.withValues(alpha: 0.7),
      ),
      labelLarge: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textColor,
      ),
      labelMedium: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textColor,
      ),
      labelSmall: GoogleFonts.notoSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textColor,
      ),
    ),
    // カードテーマ
    cardTheme: CardThemeData(
      color: AppColors.cardColor,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    // アプリバーテーマ
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardColor,
      foregroundColor: AppColors.textColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    // ボタンテーマ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // テキストボタンテーマ
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    // アウトラインボタンテーマ
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // アイコンテーマ
    iconTheme: IconThemeData(
      color: AppColors.textColor,
      size: 24,
    ),
    // スイッチテーマ
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return AppColors.textColor.withValues(alpha: 0.7);
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.textColor.withValues(alpha: 0.2);
      }),
    ),
    // スライダーテーマ
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.textColor.withValues(alpha: 0.2),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withValues(alpha: 0.1),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    ),
    // ダイアログテーマ
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor,
      ),
      contentTextStyle: GoogleFonts.notoSans(
        fontSize: 16,
        color: AppColors.textColor.withValues(alpha: 0.8),
      ),
    ),
    // ボトムシートテーマ
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.cardColor,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    // 入力デコレーションテーマ
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textColor.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: GoogleFonts.notoSans(
        fontSize: 16,
        color: AppColors.textColor.withValues(alpha: 0.5),
      ),
    ),
    // プログレスインジケーターテーマ
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      linearTrackColor: AppColors.textColor.withValues(alpha: 0.1),
      circularTrackColor: AppColors.textColor.withValues(alpha: 0.1),
    ),
    // チップテーマ
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundColor,
      selectedColor: AppColors.primaryColor.withValues(alpha: 0.1),
      disabledColor: AppColors.textColor.withValues(alpha: 0.1),
      labelStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
    ),
    // リストタイルテーマ
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      ),
      subtitleTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: AppColors.textColor.withValues(alpha: 0.7),
      ),
      leadingAndTrailingTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      ),
    ),
    // ナビゲーションレールテーマ
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.cardColor,
      selectedIconTheme: IconThemeData(
        color: AppColors.primaryColor,
        size: 24,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.textColor.withValues(alpha: 0.7),
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      unselectedLabelTextStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor.withValues(alpha: 0.7),
      ),
    ),
    // ボトムナビゲーションバーテーマ
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textColor.withValues(alpha: 0.7),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    // フローティングアクションボタンテーマ
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    // スナックバーテーマ
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textColor,
      contentTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    // ツールチップテーマ
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.textColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.notoSans(
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );

  // ダークテーマ
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      surface: AppColors.darkCardColor,
      background: AppColors.darkBackgroundColor,
    ),
    textTheme: GoogleFonts.notoSansTextTheme().copyWith(
      displayLarge: GoogleFonts.notoSans(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: AppColors.darkTextColor,
      ),
      displayMedium: GoogleFonts.notoSans(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      displaySmall: GoogleFonts.notoSans(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      headlineLarge: GoogleFonts.notoSans(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      headlineSmall: GoogleFonts.notoSans(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.darkTextColor,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.darkTextColor,
      ),
      titleSmall: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.darkTextColor,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.darkTextColor,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.darkTextColor,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.darkTextColor.withValues(alpha: 0.7),
      ),
      labelLarge: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.darkTextColor,
      ),
      labelMedium: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.darkTextColor,
      ),
      labelSmall: GoogleFonts.notoSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.darkTextColor,
      ),
    ),
    // ダークテーマ用のカードテーマ
    cardTheme: CardThemeData(
      color: AppColors.darkCardColor,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    // ダークテーマ用のアプリバーテーマ
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkCardColor,
      foregroundColor: AppColors.darkTextColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextColor,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    // ダークテーマ用のボタンテーマ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // ダークテーマ用のテキストボタンテーマ
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    // ダークテーマ用のアウトラインボタンテーマ
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // ダークテーマ用のアイコンテーマ
    iconTheme: IconThemeData(
      color: AppColors.darkTextColor,
      size: 24,
    ),
    // ダークテーマ用のスイッチテーマ
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return AppColors.darkTextColor.withValues(alpha: 0.7);
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.darkTextColor.withValues(alpha: 0.2);
      }),
    ),
    // ダークテーマ用のスライダーテーマ
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.darkTextColor.withValues(alpha: 0.2),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withValues(alpha: 0.1),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    ),
    // ダークテーマ用のダイアログテーマ
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextColor,
      ),
      contentTextStyle: GoogleFonts.notoSans(
        fontSize: 16,
        color: AppColors.darkTextColor.withValues(alpha: 0.8),
      ),
    ),
    // ダークテーマ用のボトムシートテーマ
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkCardColor,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    // ダークテーマ用の入力デコレーションテーマ
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkTextColor.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: GoogleFonts.notoSans(
        fontSize: 16,
        color: AppColors.darkTextColor.withValues(alpha: 0.5),
      ),
    ),
    // ダークテーマ用のプログレスインジケーターテーマ
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      linearTrackColor: AppColors.darkTextColor.withValues(alpha: 0.1),
      circularTrackColor: AppColors.darkTextColor.withValues(alpha: 0.1),
    ),
    // ダークテーマ用のチップテーマ
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkBackgroundColor,
      selectedColor: AppColors.primaryColor.withValues(alpha: 0.1),
      disabledColor: AppColors.darkTextColor.withValues(alpha: 0.1),
      labelStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
    ),
    // ダークテーマ用のリストタイルテーマ
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextColor,
      ),
      subtitleTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: AppColors.darkTextColor.withValues(alpha: 0.7),
      ),
      leadingAndTrailingTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextColor,
      ),
    ),
    // ダークテーマ用のナビゲーションレールテーマ
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.darkCardColor,
      selectedIconTheme: IconThemeData(
        color: AppColors.primaryColor,
        size: 24,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.darkTextColor.withValues(alpha: 0.7),
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      unselectedLabelTextStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextColor.withValues(alpha: 0.7),
      ),
    ),
    // ダークテーマ用のボトムナビゲーションバーテーマ
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.darkTextColor.withValues(alpha: 0.7),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    // ダークテーマ用のフローティングアクションボタンテーマ
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    // ダークテーマ用のスナックバーテーマ
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkTextColor,
      contentTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    // ダークテーマ用のツールチップテーマ
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.darkTextColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.notoSans(
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );
} 