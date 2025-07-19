import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings/setting_tile.dart';
import '../widgets/settings/time_picker_dialog.dart' as custom;
import '../widgets/settings/premium_banner.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          '⚙️ 設定',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final settings = settingsProvider.settings;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 外観設定
              _buildSectionHeader('🎨 外観設定'),
              SettingTile(
                title: 'ダークモード',
                subtitle: '目に優しい夜間モード',
                trailing: Switch(
                  value: settings.darkModeEnabled,
                  onChanged: settingsProvider.toggleDarkMode,
                  activeColor: AppColors.primaryColor,
                ),
              ),
              SettingTile(
                title: 'カラーテーマ',
                subtitle: 'オーシャン',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: カラーテーマ選択ダイアログ
                },
              ),
              
              const SizedBox(height: 24),
              
              // タイマー設定
              _buildSectionHeader('⏱️ タイマー設定'),
              SettingTile(
                title: '作業時間',
                subtitle: '${settings.workDuration}分',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '作業時間を設定',
                  settings.workDuration,
                  (value) => settingsProvider.updateWorkDuration(value),
                ),
              ),
              SettingTile(
                title: '短い休憩',
                subtitle: '${settings.shortBreakDuration}分',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '短い休憩時間を設定',
                  settings.shortBreakDuration,
                  (value) => settingsProvider.updateShortBreakDuration(value),
                ),
              ),
              SettingTile(
                title: '長い休憩',
                subtitle: '${settings.longBreakDuration}分',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '長い休憩時間を設定',
                  settings.longBreakDuration,
                  (value) => settingsProvider.updateLongBreakDuration(value),
                ),
              ),
              SettingTile(
                title: '自動開始',
                subtitle: '次のセッションを自動で開始',
                trailing: Switch(
                  value: settings.autoStart,
                  onChanged: settingsProvider.toggleAutoStart,
                  activeColor: AppColors.primaryColor,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 音声・通知設定
              _buildSectionHeader('🔊 音声・通知設定'),
              SettingTile(
                title: 'アラーム音',
                subtitle: 'セッション完了時の音声通知',
                trailing: Switch(
                  value: settings.soundEnabled,
                  onChanged: settingsProvider.toggleSound,
                  activeColor: AppColors.primaryColor,
                ),
              ),
              if (settings.soundEnabled) ...[
                SettingTile(
                  title: '音量',
                  subtitle: '${(settings.volume * 100).toInt()}%',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showVolumeSlider(context, settingsProvider),
                ),
                SettingTile(
                  title: '音声選択',
                  subtitle: settings.selectedSound,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 音声選択ダイアログ
                  },
                ),
              ],
              SettingTile(
                title: 'バイブレーション',
                subtitle: 'セッション完了時の振動',
                trailing: Switch(
                  value: settings.vibrationEnabled,
                  onChanged: settingsProvider.toggleVibration,
                  activeColor: AppColors.primaryColor,
                ),
              ),
              if (settings.vibrationEnabled)
                SettingTile(
                  title: '振動強度',
                  subtitle: _getVibrationIntensityText(settings.vibrationIntensity),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showVibrationIntensityDialog(context, settingsProvider),
                ),
              
              const SizedBox(height: 24),
              
              // AI機能設定
              _buildSectionHeader('🤖 AI機能設定'),
              SettingTile(
                title: 'AI分析',
                subtitle: '集中パターンの自動分析',
                trailing: Switch(
                  value: settings.aiEnabled,
                  onChanged: settingsProvider.toggleAI,
                  activeColor: AppColors.aiPrimaryColor,
                ),
              ),
              if (settings.aiEnabled)
                SettingTile(
                  title: 'AI提案',
                  subtitle: 'パーソナライズされたアドバイス',
                  trailing: Switch(
                    value: settings.aiSuggestionsEnabled,
                    onChanged: settingsProvider.toggleAISuggestions,
                    activeColor: AppColors.aiPrimaryColor,
                  ),
                ),
              if (settings.aiEnabled)
                SettingTile(
                  title: 'データ収集',
                  subtitle: '匿名化された使用データの収集',
                  trailing: Switch(
                    value: true, // 常にON
                    onChanged: null,
                    activeColor: AppColors.aiPrimaryColor,
                  ),
                ),
              if (settings.aiEnabled)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.aiPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.aiPrimaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'データは匿名化され、個人を特定できない形で処理されます',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppColors.aiPrimaryColor,
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // プレミアム機能
              _buildSectionHeader('💎 プレミアム機能'),
              const PremiumBanner(),
              
              const SizedBox(height: 24),
              
              // その他
              _buildSectionHeader('ℹ️ その他'),
              SettingTile(
                title: '言語',
                subtitle: settings.preferredLanguage == 'ja' ? '日本語' : 'English',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 言語選択ダイアログ
                },
              ),
              SettingTile(
                title: 'バージョン',
                subtitle: AppConstants.appVersion,
                trailing: null,
              ),
              SettingTile(
                title: 'フィードバック送信',
                subtitle: 'アプリの改善にご協力ください',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: フィードバック送信
                },
              ),
              SettingTile(
                title: 'プライバシーポリシー',
                subtitle: 'データの取り扱いについて',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: プライバシーポリシー表示
                },
              ),
              
              const SizedBox(height: 32),
              
              // デフォルトに戻すボタン
              Center(
                child: TextButton(
                  onPressed: () => _showResetDialog(context, settingsProvider),
                  child: Text(
                    'デフォルト設定に戻す',
                    style: GoogleFonts.notoSans(
                      color: AppColors.errorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    String title,
    int currentValue,
    Function(int) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => custom.TimePickerDialog(
        title: title,
        currentValue: currentValue,
        onChanged: onChanged,
      ),
    );
  }

  void _showVolumeSlider(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('音量設定', style: GoogleFonts.notoSans()),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: settingsProvider.settings.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      settingsProvider.updateVolume(value);
                    });
                  },
                ),
                Text(
                  '${(settingsProvider.settings.volume * 100).toInt()}%',
                  style: GoogleFonts.notoSans(fontSize: 16),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: GoogleFonts.notoSans()),
          ),
        ],
      ),
    );
  }

  void _showVibrationIntensityDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('振動強度設定', style: GoogleFonts.notoSans()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i <= 3; i++)
              RadioListTile<int>(
                title: Text(_getVibrationIntensityText(i)),
                value: i,
                groupValue: settingsProvider.settings.vibrationIntensity,
                onChanged: (value) {
                  if (value != null) {
                    settingsProvider.updateVibrationIntensity(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  String _getVibrationIntensityText(int intensity) {
    switch (intensity) {
      case 0:
        return 'なし';
      case 1:
        return '弱';
      case 2:
        return '中';
      case 3:
        return '強';
      default:
        return '中';
    }
  }

  void _showResetDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('設定をリセット', style: GoogleFonts.notoSans()),
        content: Text(
          'すべての設定をデフォルトに戻しますか？',
          style: GoogleFonts.notoSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('キャンセル', style: GoogleFonts.notoSans()),
          ),
          TextButton(
            onPressed: () {
              settingsProvider.resetToDefaults();
              Navigator.of(context).pop();
            },
            child: Text(
              'リセット',
              style: GoogleFonts.notoSans(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
} 