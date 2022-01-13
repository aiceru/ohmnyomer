import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ohmnyomer/src/models/credential.dart';


class CredentialProvider {
  static final _storage = FlutterSecureStorage();

  Future<Credential?> loadCredential() async {
    String? jsonCred = await _storage.read(key: "cred");
    if (jsonCred != null) {
      return Credential.fromJson(jsonDecode(jsonCred));
    }
    return null;
  }

  saveCredential(cred) {
    _storage.write(key: "cred", value: jsonEncode(cred));
  }

  deleteCredential() {
    _storage.delete(key: "cred");
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
