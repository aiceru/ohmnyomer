import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:share_plus/share_plus.dart';


class Inviter {
  static final Inviter _inviter = Inviter._createInstance();
  Inviter._createInstance();
  factory Inviter() {
    return _inviter;
  }

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    await Firebase.initializeApp();
    _isInitialized = true;
  }

  share(String petId, String petName, String petFamily) {
    _createDynamicLink(petId, petName, petFamily).then((value) {
      Share.share(value.toString());
    });
  }

  Future<Uri> _createDynamicLink(String petId, String petName, String petFamily) async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://ohmnyom.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://ohmnyom.io/co-parenting?id=$petId&name=$petName&family=$petFamily'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: kReleaseMode ? androidPackageName : androidPackageNameDebug,
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      // iosParameters: const IOSParameters(
      //   bundleId: iosBundleId,
      //   minimumVersion: '2',
      // ),
    );

    var shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl;
  }


}

