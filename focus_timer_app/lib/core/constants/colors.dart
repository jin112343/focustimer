import 'package:flutter/material.dart';

class AppColors {
  // プライマリカラー
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFFA29BFE);
  
  // セッション別カラー
  static const Color workColor = Color(0xFFE17055);
  static const Color shortBreakColor = Color(0xFF00B894);
  static const Color longBreakColor = Color(0xFF0984E3);
  
  // ニュートラルカラー
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color textColor = Color(0xFF2D3436);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  
  // ダークモード対応
  static const Color darkBackgroundColor = Color(0xFF1A1A1A);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkSurfaceColor = Color(0xFF3D3D3D);
  
  // 状態カラー
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFFDCB6E);
  static const Color errorColor = Color(0xFFE17055);
  static const Color infoColor = Color(0xFF0984E3);
  
  // AI関連カラー
  static const Color aiPrimaryColor = Color(0xFF6C5CE7);
  static const Color aiSecondaryColor = Color(0xFFA29BFE);
  static const Color aiAccentColor = Color(0xFFFD79A8);
  
  // AIグラデーション
  static const LinearGradient aiPrimaryGradient = LinearGradient(
    colors: [aiPrimaryColor, aiSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // グラデーション
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient workGradient = LinearGradient(
    colors: [workColor, Color(0xFFF39C12)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient breakGradient = LinearGradient(
    colors: [shortBreakColor, longBreakColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 