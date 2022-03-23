import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static final AdHelper _adHelper = AdHelper._createInstance();
  AdHelper._createInstance();
  factory AdHelper() {
    return _adHelper;
  }

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    }
  }

  void loadBanner(Function(BannerAd) onBannerAdLoaded) async {
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
    if (kReleaseMode) {
      return 'ca-app-pub-3617657034378751/7212213365';
    }
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