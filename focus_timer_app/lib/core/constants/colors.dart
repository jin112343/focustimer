import 'package:flutter/material.dart';

class AppColors {
  // 3色カラーパレット
  static const Color primaryColor = Color(0xFF00FFFF);    // ネオンブルー
  static const Color secondaryColor = Color(0xFFFF00FF);  // ネオンピンク
  static const Color accentColor = Color(0xFFFFFF00);     // ネオンイエロー
  
  // ニュートラルカラー
  static const Color backgroundColor = Color(0xFF181A20); // ダークグレー
  static const Color textColor = Color(0xFFFFFFFF);         // 白
  static const Color cardColor = Color(0xFF23262F);         // 濃いグレー
  static const Color surfaceColor = Color(0xFFF9FAFB);      // ライトグレー
  
  // ダークモード対応
  static const Color darkBackgroundColor = Color(0xFF111827); // ダークグレー
  static const Color darkTextColor = Color(0xFFF9FAFB);      // ライトグレー
  static const Color darkCardColor = Color(0xFF1F2937);      // ダークグレー
  static const Color darkSurfaceColor = Color(0xFF374151);   // ダークグレー
  
  // 状態カラー（3色ベース）
  static const Color successColor = Color(0xFF00FF00);      // ネオングリーン
  static const Color warningColor = Color(0xFFFFFF00);      // ネオンイエロー
  static const Color errorColor = Color(0xFFFF00FF);        // ネオンピンク
  static const Color infoColor = Color(0xFF00FFFF);         // ネオンブルー
  
  // AI関連カラー（3色ベース）
  static const Color aiPrimaryColor = Color(0xFF00FF00);    // ネオングリーン
  static const Color aiSecondaryColor = Color(0xFF23262F);  // ダークネイビー
  static const Color aiAccentColor = Color(0xFFFF00FF);     // ネオンピンク
  
  // セッション別カラー（3色ベース）
  static const Color workColor = primaryColor;         // ネオンブルー
  static const Color shortBreakColor = secondaryColor;   // ネオンピンク
  static const Color longBreakColor = accentColor;    // ネオンイエロー
  
  // グラデーション（3色ベース）
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryColor, accentColor, aiPrimaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient aiPrimaryGradient = LinearGradient(
    colors: [aiPrimaryColor, aiSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient workGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient breakGradient = LinearGradient(
    colors: [accentColor, aiPrimaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // 金色グラデーション（高級感用）
  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFFFF6C3), // ハイライト
      Color(0xFFFFD700), // 明るいゴールド
      Color(0xFFBFA14A), // ベース
      Color(0xFF8C7A2A), // シャドウ
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // アクセシビリティカラー
  static const Color highContrastTextColor = Color(0xFF000000);
  static const Color highContrastBackgroundColor = Color(0xFFFFFFFF);
  static const Color focusIndicatorColor = Color(0xFF6366F1);
  static const Color screenReaderTextColor = Color(0xFF6B7280);
  
  // AIインサイト画面専用グラデーション
  static const LinearGradient aiInsightGradient = LinearGradient(
    colors: [
      Color(0xFF00FF00), // ネオングリーン
      Color(0xFF00FFFF), // ネオンブルー
      Color(0xFFFF00FF), // ネオンピンク
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 