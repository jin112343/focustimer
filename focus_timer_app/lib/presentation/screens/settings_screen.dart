import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings/setting_tile.dart';
import '../widgets/settings/time_picker_dialog.dart' as custom;
import '../widgets/settings/premium_banner.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          '⚙️ ' + AppLocalizations.of(context)!.settings,
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
              
              // タイマー設定
              _buildSectionHeader(context, '⏱️ タイマー設定'),
              SettingTile(
                title: '作業時間',
                subtitle: '${settings.workDurationSeconds ~/ 60}分${settings.workDurationSeconds % 60 > 0 ? ' ${settings.workDurationSeconds % 60}秒' : ''}',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '作業時間を設定',
                  settings.workDurationSeconds ~/ 60,
                  settings.workDurationSeconds % 60,
                  (min, sec) => settingsProvider.updateWorkDuration(min * 60 + sec),
                ),
              ),
              SettingTile(
                title: '短い休憩',
                subtitle: '${settings.shortBreakDurationSeconds ~/ 60}分${settings.shortBreakDurationSeconds % 60 > 0 ? ' ${settings.shortBreakDurationSeconds % 60}秒' : ''}',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '短い休憩時間を設定',
                  settings.shortBreakDurationSeconds ~/ 60,
                  settings.shortBreakDurationSeconds % 60,
                  (min, sec) => settingsProvider.updateShortBreakDuration(min * 60 + sec),
                ),
              ),
              SettingTile(
                title: '長い休憩',
                subtitle: '${settings.longBreakDurationSeconds ~/ 60}分${settings.longBreakDurationSeconds % 60 > 0 ? ' ${settings.longBreakDurationSeconds % 60}秒' : ''}',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimePickerDialog(
                  context,
                  '長い休憩時間を設定',
                  settings.longBreakDurationSeconds ~/ 60,
                  settings.longBreakDurationSeconds % 60,
                  (min, sec) => settingsProvider.updateLongBreakDuration(min * 60 + sec),
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
              _buildSectionHeader(context, '🔊 音声・通知設定'),
              SettingTile(
                title: '音声',
                subtitle: 'セッション完了時の音声',
                trailing: Switch(
                  value: settings.soundEnabled,
                  onChanged: settingsProvider.toggleSound,
                  activeColor: AppColors.primaryColor,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // AI機能設定
              _buildSectionHeader(context, '🤖 AI機能設定'),
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
              
              // その他
              _buildSectionHeader(context, 'ℹ️ その他'),
              SettingTile(
                title: AppLocalizations.of(context)!.version,
                subtitle: '1.0.0',
                trailing: null,
              ),
              SettingTile(
                title: AppLocalizations.of(context)!.feedback,
                subtitle: AppLocalizations.of(context)!.feedbackSubtitle,
                trailing: const Icon(Icons.chevron_right),
                // onTap: () => _showFeedbackDialog(context),
              ),
              // TODO: フィードバック送信
              // フィードバック送信ボタンで、入力内容を（仮実装として）ローカル保存 or SnackBarで「送信完了」と表示
              // 実際の送信先（メールやAPI）は後で拡張可能
              SettingTile(
                title: AppLocalizations.of(context)!.privacyPolicy,
                subtitle: AppLocalizations.of(context)!.privacyPolicySubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPrivacyPolicy(context),
              ),
              
              const SizedBox(height: 32),
              
              // デフォルトに戻すボタン
              Center(
                child: TextButton(
                  onPressed: () => _showResetDialog(context, settingsProvider),
                  child: Text(
                    AppLocalizations.of(context)!.resetToDefault,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    final titles = {
      '⏱️ タイマー設定': '⏱️ ' + l10n.timerSettings,
      '🔊 音声・通知設定': '🔊 ' + l10n.soundAndNotifications,
      '🤖 AI機能設定': '🤖 ' + l10n.aiFeatures,
      'ℹ️ その他': 'ℹ️ ' + l10n.others,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        titles[title] ?? title,
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
    int currentMinutes,
    int currentSeconds,
    Function(int, int) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => custom.TimePickerDialog(
        title: title,
        currentMinutes: currentMinutes,
        currentSeconds: currentSeconds,
        onChanged: onChanged,
      ),
    );
  }



  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('フィードバック送信', style: GoogleFonts.notoSans()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'アプリの改善のため、ご意見をお聞かせください。',
              style: GoogleFonts.notoSans(),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'フィードバックを入力してください...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('キャンセル', style: GoogleFonts.notoSans()),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 実際のフィードバック送信処理
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'フィードバックを送信しました。ありがとうございます！',
                    style: GoogleFonts.notoSans(),
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text('送信', style: GoogleFonts.notoSans()),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('プライバシーポリシー', style: GoogleFonts.notoSans()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'データの取り扱いについて',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '• アプリ内で収集されるデータは、AI分析のため匿名化して処理されます\n'
                '• 個人を特定できる情報は収集・保存されません\n'
                '• データはローカルデバイスに保存され、外部に送信されることはありません\n'
                '• AI機能を使用する場合のみ、匿名化されたデータがGemini APIに送信されます',
                style: GoogleFonts.notoSans(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('閉じる', style: GoogleFonts.notoSans()),
          ),
        ],
      ),
    );
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