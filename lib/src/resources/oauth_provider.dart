import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakaosdk;
import 'package:ohmnyomer/src/constants.dart';

class OAuthIdentity {
  String name;
  String email;
  String provider;
  String id;
  String photourl;

  OAuthIdentity(this.name, this.email, this.provider, this.id, this.photourl);
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class OAuthProvider {
  OAuthProvider() {
    _googleSignIn.signInSilently();
    kakaosdk.KakaoContext.clientId = "4e54eb14cdee9e5e27da630b30c02a2b";
  }

  Future<OAuthIdentity> getGoogleIdentity() async {
    GoogleSignInAccount? gAccount;
    await _googleSignIn.signIn();
    gAccount = _googleSignIn.currentUser;
    if (gAccount != null) {
      return OAuthIdentity(
        gAccount.displayName ?? "google-"+gAccount.id,
        gAccount.email,
        oauthProviderGoogle,
        gAccount.id,
        gAccount.photoUrl ?? "",
      );
    }
    return Future.error('google account is nil');
  }

  Future<OAuthIdentity> getKakaoIdentity() async {
    await kakaosdk.UserApi.instance.loginWithKakaoTalk();
    var me = await kakaosdk.UserApi.instance.me();
    var kAccount = me.kakaoAccount;
    if (kAccount != null) {
      kakaosdk.UserApi.instance.logout();
      return OAuthIdentity(
        kAccount.profile?.nickname ?? "kakao-"+me.id.toString(),
        kAccount.email ?? "",
        oauthProviderKakao,
        me.id.toString(),
        kAccount.profile?.profileImageUrl ?? "",
      );
    }
    return Future.error('kakao account is nil');
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

  // signOut(Account account) {
  //   // TODO: implement?
  // }
}