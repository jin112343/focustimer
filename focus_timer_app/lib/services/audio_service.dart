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
    // TODO: 通知音の実装（現状は何もしない）
    // final player = AudioPlayer();
    // await player.play(AssetSource('sounds/notification_simple.mp3'));
    // 通知音は後で実装予定。今は何もしない。
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
    if (!await Vibration.hasVibrator() ?? false) return;

    final intensity = settings.vibrationIntensity;
    final pattern = _getVibrationPattern(intensity);
    if (pattern.isEmpty) return;

    // iOS/Android両対応: iOSはパターン未対応なのでdurationのみ
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      await Vibration.vibrate(pattern: pattern);
    } else {
      // 最初のdurationだけ使う
      await Vibration.vibrate(duration: pattern.length > 1 ? pattern[1] : 200);
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