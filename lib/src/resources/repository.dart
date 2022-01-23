import 'package:dartnyom/model.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/models/credential.dart';
import 'package:ohmnyomer/src/resources/credential_provider.dart';
import 'package:ohmnyomer/src/resources/sign_api_provider.dart';
import 'package:ohmnyomer/src/resources/oauth_provider.dart';

class Repository {
  static final Repository _repository = Repository._createInstance();
  Repository._createInstance();

  factory Repository() {
    return _repository;
  }

  Account? _account;
  final _credentialProvider = CredentialProvider();
  final _signApiProvider = SignApiProvider();

  Future<Account?> fetchAccount() async {
    if (_account != null) {
      return Future<Account?>.value(_account);
    }
    // if autologin
    Credential? cred = await _credentialProvider.loadCredential();
    if (cred != null) {
      if (cred.password != null) {
        return _signApiProvider.signInWithEmail(cred.email, cred.password);
      } else if (cred.oauthinfo != null) {
        return _signApiProvider.signInWithOAuthInfo(cred.email, cred.oauthinfo!);
      }
    }
    return null;
  }

  Future<Account> signUpWithEmail(String name, email, password) async {
    _account = await _signApiProvider.signUpWithEmail(name, email, password);
    _credentialProvider.saveCredential(
        Credential(_account!.email, password: password));
    return _account!;
  }

  Future<Account> signUpWithOAuthInfo(
      String name, email, OAuthInfo info, String photourl) async {
    _account = await _signApiProvider.signUpWithOAuthInfo(
        name, email, info, photourl);
    _credentialProvider.saveCredential(
        Credential(_account!.email, oauthinfo: _account!.oauthinfo[0]));
    return _account!;
  }

  Future<Account> signInWithEmail(String email, password) async {
    _account = await _signApiProvider.signInWithEmail(email, password);
    _credentialProvider.saveCredential(
        Credential(_account!.email, password: password));
    return _account!;
  }

  Future<Account> signInWithOAuthInfo(String email, OAuthInfo info) async {
    _account = await _signApiProvider.signInWithOAuthInfo(email, info);
    _credentialProvider.saveCredential(
        Credential(_account!.email, oauthinfo: _account!.oauthinfo[0]));
    return _account!;
  }

  signOut() {
    // TODO: remove credential
    // TODO: remove token
    // do nothing now
  }
}