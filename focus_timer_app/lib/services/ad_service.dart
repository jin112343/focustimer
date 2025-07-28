import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  bool get isInitialized => _isInitialized;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  Future<void> initialize() async {
    if (_isInitialized) {
      print('AdMob already initialized');
      return;
    }

    try {
      print('Initializing AdMob...');
      await MobileAds.instance.initialize();
      _isInitialized = true;
      print('AdMob initialized successfully');
    } catch (e) {
      print('AdMob initialization failed: $e');
    }
  }

  Future<void> loadBannerAd() async {
    if (!_isInitialized) {
      print('AdMob not initialized, initializing...');
      await initialize();
    }

    try {
      print('Loading banner ad...');
      
      // 実際の広告ユニットID（本番環境）
      const adUnitId = kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111' // テスト用バナー広告ID
          : 'ca-app-pub-1187210314934709/1524491114'; // 本番用バナー広告ID
      
      print('Using ad unit ID: $adUnitId');

      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Banner ad loaded successfully');
            _isBannerAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner ad failed to load: $error');
            print('Error code: ${error.code}');
            print('Error message: ${error.message}');
            _isBannerAdLoaded = false;
            ad.dispose();
          },
          onAdOpened: (ad) {
            print('Banner ad opened');
          },
          onAdClosed: (ad) {
            print('Banner ad closed');
          },
        ),
      );

      print('Banner ad created, loading...');
      await _bannerAd!.load();
      print('Banner ad load request completed');
    } catch (e) {
      print('Failed to load banner ad: $e');
      _isBannerAdLoaded = false;
    }
  }

  Widget? getBannerAdWidget() {
    print('Getting banner ad widget...');
    print('Banner ad loaded: $_isBannerAdLoaded');
    print('Banner ad object: ${_bannerAd != null ? 'exists' : 'null'}');
    
    if (_bannerAd != null && _isBannerAdLoaded) {
      print('Returning banner ad widget');
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      print('Banner ad not available');
      return null;
    }
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }
} 