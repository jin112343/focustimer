import 'dart:io';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../data/models/settings.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      print('AudioService already initialized');
      return;
    }
    
    try {
      print('Initializing AudioService...');
      // 無限ループを止めて一回のみ再生
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
      print('AudioService initialized successfully');
    } catch (e) {
      print('AudioService initialization failed: $e');
    }
  }

  Future<void> playNotificationSound(Settings settings) async {
    try {
      print('Playing notification sound...');
      print('Sound enabled: ${settings.soundEnabled}');
      print('⚠️ デバイスの音量とサイレントモードを確認してください');
      print('📱 音量ボタンで音量を上げてください');
      print('🔇 サイレントモードがオフになっているか確認してください');
      
      if (!settings.soundEnabled) {
        print('Sound is disabled in settings');
        return;
      }
      
      // 既に再生中の場合は開始しない
      if (_isPlaying) {
        print('Sound is already playing, skipping...');
        return;
      }
      
      // カスタム音声ファイルを再生（一回のみ）
      print('Playing custom sound file: Countdown06-1.mp3 (single play)');
      await _playCustomSound();
      
      print('Notification sound played successfully');
    } catch (e) {
      print('Failed to play notification sound: $e');
    }
  }

  Future<void> _playCustomSound() async {
    try {
      print('Playing custom sound file: Countdown06-1.mp3 (single play)...');
      
      // カスタム音声ファイルを再生（一回のみ）
      await _audioPlayer.play(AssetSource('sounds/Countdown06-1.mp3'));
      _isPlaying = true;
      print('Custom sound file started playing (single play)');
      
      // 3.5秒後に自動停止（音声ファイルの長さに合わせて）
      await Future.delayed(const Duration(milliseconds: 3500));
      await stopSound();
      
    } catch (e) {
      print('Failed to play custom sound file: $e');
      print('Using fallback system sound...');
      
      // フォールバック: システムサウンドを使用
      try {
        await SystemSound.play(SystemSoundType.alert);
        print('Fallback system sound played');
      } catch (fallbackError) {
        print('Fallback system sound also failed: $fallbackError');
      }
    }
  }

  Future<void> stopSound() async {
    try {
      if (_isPlaying) {
        print('Stopping sound...');
        await _audioPlayer.stop();
        _isPlaying = false;
        print('Sound stopped successfully');
      }
    } catch (e) {
      print('Failed to stop sound: $e');
    }
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _audioPlayer.dispose();
  }
} 