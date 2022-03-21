import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static final AdHelper _adHelper = AdHelper._createInstance();
  AdHelper._createInstance();
  factory AdHelper() {
    return _adHelper;
  }

  static bool _isInitialized = false;

  static Future<void> _initialize() async {
    if (!_isInitialized) {
      debugPrint('AdHelper initialize()');
      await MobileAds.instance.initialize();
      _isInitialized = true;
    }
    debugPrint('AdHelper initialize() - already initialized');
  }

  void loadBanner(Function(BannerAd) onBannerAdLoaded) async {
    await _initialize();

    BannerAd banner = BannerAd(
      size: AdSize.banner,
      adUnitId: _getBannerAdUnitId(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onBannerAdLoaded(ad as BannerAd);
        }
      ),
      request: const AdRequest(),
    );
    await banner.load();
  }

  EdgeInsets getFabPadding() {
    double bannerHeight = 50.0;
    return EdgeInsets.only(bottom: bannerHeight);
  }

  EdgeInsets _getBannerTopPadding() {
    return const EdgeInsets.only(top: 4.0);
  }

  String _getBannerAdUnitId() {
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  Widget bottomBannerWidget(BannerAd banner) {
    return Padding(
      padding: _getBannerTopPadding(),
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }
}