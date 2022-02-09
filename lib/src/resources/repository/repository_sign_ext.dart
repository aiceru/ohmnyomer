import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/models/credential.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/resources/apis/sign_api_provider.dart';

extension RepositorySignExt on Repository {
  Future<SignInResult> signInWithCredential() async {
    Credential? cred = await credentialProvider.loadCredential();
    SignInResult result = SignInResult.fail;
    if (cred != null) {
      if (cred.password != null) {
        result = await signInWithEmail(cred.email, cred.password);
      } else if (cred.oauthinfo != null && cred.oauthProvider != null) {
        result = await signInWithOAuthInfo(cred.oauthinfo!, cred.oauthProvider!);
      }
    }
    return result;
  }

  Future<SignInResult> signUpWithEmail(String name, email, password) async {
    Authorization auth = await signApiProvider.signUpWithEmail(name, email, password);
    account = auth.account;
    authToken = auth.token;

    return SignInResult.success;
  }

  Future<SignInResult> signUpWithOAuthInfo(
      String name, OAuthInfo info, String provider, String photourl) async {
    Authorization auth = await signApiProvider.signUpWithOAuthInfo(
        name, info, provider, photourl);
    account = auth.account;
    authToken = auth.token;

    return SignInResult.success;
  }

  Future<SignInResult> signInWithEmail(String email, password) async {
    Authorization auth = await signApiProvider.signInWithEmail(email, password);
    account = auth.account;
    authToken = auth.token;

    if (rememberMe) {
      signInEmail = email;
    }

    if (autoSignIn) {
      credentialProvider.saveCredential(Credential(account!.email, password: password));
    }
    return SignInResult.success;
  }

  Future<SignInResult> signInWithOAuthInfo(OAuthInfo info, String provider) async {
    Authorization auth = await signApiProvider.signInWithOAuthInfo(info, provider);
    account = auth.account;
    authToken = auth.token;

    if (autoSignIn) {
      credentialProvider.saveCredential(Credential(account!.email,
          oauthProvider: provider, oauthinfo: account!.oauthinfo[provider]));
    }
    return SignInResult.success;
  }

  signOut() {
    account = null;
    authToken = null;

    credentialProvider.deleteCredential();
  }
}