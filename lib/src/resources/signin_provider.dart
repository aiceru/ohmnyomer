import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakaosdk;
import 'package:ohmnyomer/src/models/account.dart';
import 'package:ohmnyomer/src/models/credential.dart';
import 'package:ohmnyomer/src/resources/signin_api_provider.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class SignInProvider {
  final SignInApiProvider apiProvider = SignInApiProvider();

  SignInProvider() {
    _googleSignIn.signInSilently();
    kakaosdk.KakaoContext.clientId = "4e54eb14cdee9e5e27da630b30c02a2b";
  }

  Future<Account?> signIn(Credential cred) {
    // TODO: implement
    // sign in to the backend
    apiProvider.signIn();
    //
    Account account = Account(
        id: "test-id",
        email: cred.email?? "test-email",
        name: "testname",
        oAuthID: cred.oAuthID?? "test-oauth-id",
        oAuthType: cred.oAuthType,
        photoUrl: "https://lh3.googleusercontent.com/a-/AOh14GgW6EQt1TEkfEVQnOr66MqEXoeBxK2mi5hecvmIenU",
        signedUp: DateTime(2022, 1, 5, 13, 24),
    );

    if (cred.oAuthType == OAuthType.none) {
      // email/password sign in
    } else {
      // oauth id sign in
    }
    return Future<Account>.value(account);
  }

  temptest() {
  }

  Future<Account?> signInWithGoogle() async {
    GoogleSignInAccount? gAccount;
    Account? account;
    try {
      await _googleSignIn.signIn();
      gAccount = _googleSignIn.currentUser;
      if (gAccount != null) {
        account = await signIn(Credential(
          oAuthID: gAccount.id,
          email: gAccount.email,
          oAuthType: OAuthType.google,
        ));
        if (account != null && account.photoUrl != gAccount.photoUrl) {
          // TODO: update photoURL
          // SignInApiProvider.update...
        }
        _googleSignIn.disconnect();
      }
    } catch (error) {
      print('$error');
    }
    return account;
  }

  Future<Account?> signInWithKakao() async {
    Account? account;
    try {
      await kakaosdk.UserApi.instance.loginWithKakaoTalk();
      var me = await kakaosdk.UserApi.instance.me();
      var kAccount = me.kakaoAccount;
      if (kAccount != null) {
        account = await signIn(Credential(
          oAuthID: me.id.toString(),
          email: kAccount.email,
          oAuthType: OAuthType.kakao,
        ));
        if (account != null && account.photoUrl != kAccount.profile?.thumbnailImageUrl) {
          // TODO: update photoURL
          // SignInApiProvider.update...
        }
        kakaosdk.UserApi.instance.logout();
      }
    } catch (error) {
      print('$error');
    }
    return account;
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
    // TODO: implement?
  }
}