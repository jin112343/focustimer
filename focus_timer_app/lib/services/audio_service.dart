import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../data/models/settings.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _isInitialized = true;
    } catch (e) {
      print('AudioService initialization failed: $e');
    }
  }

  Future<void> playNotificationSound(Settings settings) async {
    if (!settings.soundEnabled) return;

    try {
      await initialize();
      
      // 音量を設定
      await _audioPlayer.setVolume(settings.volume);
      
      // 音声ファイルを再生（実際の実装では適切な音声ファイルを使用）
      await _audioPlayer.play(AssetSource('sounds/${settings.selectedSound}.mp3'));
    } catch (e) {
      print('Failed to play notification sound: $e');
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Failed to stop sound: $e');
    }
  }

  Future<void> vibrate(Settings settings) async {
    if (!settings.vibrationEnabled) return;

    try {
      if (await Vibration.hasVibrator() ?? false) {
        final pattern = _getVibrationPattern(settings.vibrationIntensity);
        await Vibration.vibrate(pattern: pattern);
      }
    } catch (e) {
      print('Failed to vibrate: $e');
    }
  }

  List<int> _getVibrationPattern(int intensity) {
    switch (intensity) {
      case 0:
        return [];
      case 1:
        return [0, 200]; // 短い振動
      case 2:
        return [0, 300, 100, 300]; // 中程度の振動
      case 3:
        return [0, 500, 200, 500, 200, 500]; // 強い振動
      default:
        return [0, 300, 100, 300];
    }
  }

  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      print('Failed to dispose AudioService: $e');
    }
  }
} 