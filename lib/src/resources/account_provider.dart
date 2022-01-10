import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ohmnyom/src/models/account.dart';


class AccountProvider {
  static final _storage = FlutterSecureStorage();

  Future<Account?> fetchAccount() async {
    String? jsonAccount = await _storage.read(key: "account");
    if (jsonAccount != null) {
      return Account.fromJson(jsonDecode(jsonAccount));
    }
    return Account(email: "");
  }
}

//
// void _handleKakaoSignIn() {
//   try {
//     UserApi.instance.loginWithKakaoTalk();
//   } catch (error) {
//     print('$error');
//   }
// }
//
// void _handleKakaoSignOut() {
//   UserApi.instance.unlink();
// }
// KakaoContext.clientId = "4e54eb14cdee9e5e27da630b30c02a2b";
//
// signInWithGoogle() async {
//   await _handleGoogleSignIn();
// }
//
// signInWithKakao() async {
//   _handleKakaoSignIn();
//   User me = await UserApi.instance.me();
//   print(me.id);
//   oAuthType = OAuthType.kakao;
// }
//
// signOut() {
//   switch (oAuthType) {
//     case OAuthType.none:
//       // TODO: Handle this case.
//       _reset();
//       break;
//     case OAuthType.google:
//       _handleGoogleSignOut();
//       _reset();
//       break;
//     case OAuthType.kakao:
//       _handleKakaoSignOut();
//       _reset();
//       break;
//     case OAuthType.naver:
//       // TODO: Handle this case.
//       email = ""; name = ""; oAuthType = OAuthType.none;
//       break;
//   }
// }
