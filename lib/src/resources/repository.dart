import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/credential_provider.dart';
import 'package:ohmnyomer/src/resources/sign_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static final Repository _repository = Repository._createInstance();
  Repository._createInstance() {}

  factory Repository() {
    return _repository;
  }

  Account? _account;
  String? _authToken;

  SharedPreferences? _prefs;
  final _credentialProvider = CredentialProvider();
  final _signApiProvider = SignApiProvider();

  bool _rememberMe = false;

  bool get rememberMe => _rememberMe;
  set rememberMe(bool value) {
    _setBoolPref(sharedPrefRememberMeKey, value);
    _rememberMe = value;
    if (!value) {
      _removePref(sharedPrefEmailKey);
      _signInEmail = "";
    }
  }

  bool _autoSignIn = false;

  bool get autoSignIn => _autoSignIn;
  set autoSignIn(bool value) {
    _setBoolPref(sharedPrefAutoLoginKey, value);
    _autoSignIn = value;
  }

  String _signInEmail = "";

  String get signInEmail => _signInEmail;

  init(SharedPreferences prefs) {
    _prefs = prefs;
    _autoSignIn = _getBoolPref(sharedPrefAutoLoginKey);
    _rememberMe = _getBoolPref(sharedPrefRememberMeKey);
    _signInEmail = _getStringPref(sharedPrefEmailKey);
  }

  bool _getBoolPref(String key) {
    return _prefs?.getBool(key) ?? false;
  }
  _setBoolPref(String key, bool value) {
    _prefs?.setBool(key, value);
  }

  String _getStringPref(String key) {
    return _prefs?.getString(key) ?? "";
  }
  _setStringPref(String key, value) {
    _prefs?.setString(key, value);
  }

  _removePref(String key) async {
    _prefs?.remove(key);
  }

  Future<Account?> fetchAccount() async {
    if (_account != null) {
      return Future<Account?>.value(_account);
    }
    // if (_autoLogin) {
    //   Credential? cred = await _credentialProvider.loadCredential();
    //   if (cred != null) {
    //     // if (cred.password != null) {
    //     //   return _signApiProvider.signInWithEmail(cred.email, cred.password);
    //     // } else if (cred.oauthinfo != null) {
    //     //   return _signApiProvider.signInWithOAuthInfo(cred.email, cred.oauthinfo!);
    //     // }
    //   }
    // }
    return null;
  }

  Future<SignInResult> signUpWithEmail(String name, email, password) async {
    Authorization auth = await _signApiProvider.signUpWithEmail(name, email, password);
    _account = auth.account;
    _authToken = auth.token;

    // TODO: if autologin
    // _credentialProvider.saveCredential(
    //     Credential(_account!.email, password: password));
    return SignInResult.success;
  }

  Future<SignInResult> signUpWithOAuthInfo(
      String name, email, OAuthInfo info, String photourl) async {
    Authorization auth = await _signApiProvider.signUpWithOAuthInfo(
        name, email, info, photourl);
    _account = auth.account;
    _authToken = auth.token;

    // TODO: if autologin
    // _credentialProvider.saveCredential(
    //     Credential(_account!.email, oauthinfo: _account!.oauthinfo[0]));
    return SignInResult.success;
  }

  Future<SignInResult> signInWithEmail(String email, password) async {
    Authorization auth = await _signApiProvider.signInWithEmail(email, password);
    _account = auth.account;
    _authToken = auth.token;

    if (rememberMe) {
      _signInEmail = email;
      _setStringPref(sharedPrefEmailKey, email);
    }

    // TODO: if autologin
    // _credentialProvider.saveCredential(
    //     Credential(_account!.email, password: password));
    return SignInResult.success;
  }

  Future<SignInResult> signInWithOAuthInfo(String email, OAuthInfo info) async {
    Authorization auth = await _signApiProvider.signInWithOAuthInfo(email, info);
    _account = auth.account;
    _authToken = auth.token;

    // TODO: if autologin
    // _credentialProvider.saveCredential(
    //     Credential(_account!.email, oauthinfo: _account!.oauthinfo[0]));
    return SignInResult.success;
  }

  signOut() {
    // TODO: remove credential
    // TODO: remove token
    _account = null;
    _authToken = null;

    _credentialProvider.deleteCredential();
    // do nothing now
  }
}