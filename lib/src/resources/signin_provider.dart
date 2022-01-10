import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakaosdk;
import 'package:ohmnyom/src/models/account.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<Account> _handleGoogleSignIn() async {
  GoogleSignInAccount? gAccount;
  try {
    await _googleSignIn.signIn();
    gAccount = _googleSignIn.currentUser;
    if (gAccount != null) {
      return Account(
        email: gAccount.email,
        name: gAccount.displayName,
        oAuthType: OAuthType.google,
        photoUrl: gAccount.photoUrl,
      );
    }
  } catch (error) {
    print('$error');
  }
  return Account(email: "");
}

Future<void> _handleGoogleSignOut() => _googleSignIn.disconnect();

class SignInProvider {
  static final _storage = FlutterSecureStorage();

  SignInProvider() {
    _googleSignIn.signInSilently();
  }

  Future<Account> _signIn(Account account) {
    // TODO: implement
    // sign in to the backend
    //
    _storage.write(key: "account", value: jsonEncode(account));
    return Future<Account>.value(account);
  }

  Future<Account> signInWithGoogle() async {
    Account account = await _handleGoogleSignIn();
    return _signIn(account);
  }

  Future<Account> signInWithKakao() async {
    kakaosdk.KakaoContext.clientId = "4e54eb14cdee9e5e27da630b30c02a2b";
    try {
      await kakaosdk.UserApi.instance.loginWithKakaoTalk();
      var me = await kakaosdk.UserApi.instance.me();
      var kAccount = me.kakaoAccount;
      if (kAccount != null) {
        return Account(
          email: kAccount.email!,
          name: kAccount.name,
          oAuthType: OAuthType.kakao,
          photoUrl: kAccount.profile?.thumbnailImageUrl,
        );
      }
    } catch (error) {
      print('$error');
    }
    return Account(email: "");
  }

  //{
  // id: 2064937418,
  // properties: {
  //  nickname: 우삭,
  //  profile_image: https://k.kakaocdn.net/dn/d56EZz/btroWElj2cH/hKRv6uyJZuUtYzL2nPW8KK/img_640x640.jpg,
  //  thumbnail_image: https://k.kakaocdn.net/dn/d56EZz/btroWElj2cH/hKRv6uyJZuUtYzL2nPW8KK/img_110x110.jpg},
  //  kakao_account: {
  //    profile_nickname_needs_agreement: false,
  //    profile_image_needs_agreement: false,
  //    profile: {
  //      nickname: 우삭,
  //      thumbnail_image_url: https://k.kakaocdn.net/dn/d56EZz/btroWElj2cH/hKRv6uyJZuUtYzL2nPW8KK/img_110x110.jpg,
  //      profile_image_url: https://k.kakaocdn.net/dn/d56EZz/btroWElj2cH/hKRv6uyJZuUtYzL2nPW8KK/img_640x640.jpg,
  //      is_default_image: false
  //    },
  //    email_needs_agreement: false,
  //    is_email_valid: true,
  //    is_email_verified: true,
  //    email: aiceru@kakao.com
  //  },
  //  connected_at: 2022-01-04T13:46:04.000Z
  //}

  signOut(Account account) {
    switch (account.oAuthType) {
      case OAuthType.none:
        // TODO: Handle this case.
        break;
      case OAuthType.google:
        _handleGoogleSignOut();
        break;
      case OAuthType.kakao:
        // TODO: Handle this case.
        break;
      case OAuthType.naver:
        // TODO: Handle this case.
        break;
    }
    _storage.delete(key: "account");
  }
}